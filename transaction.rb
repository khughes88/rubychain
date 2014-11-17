require 'rubygems'

require 'json'
require 'digest'
require 'securerandom'
require 'base58'
require 'ecdsa'

def generate_keys
group = ECDSA::Group::Secp256k1
private_key = 1 + SecureRandom.random_number(group.order - 1)
p  "new private key:  #{private_key}"
public_key = group.generator.multiply_by_scalar(private_key)
public_key_string=ECDSA::Format::PointOctetString.encode(public_key)
key2="04#{public_key.x}#{public_key}"
p "new public key:  #{public_key_string}"
p public_key_string
p "key2:  #{key2}"
#Perform SHA-256 hashing on the public key 
sha256= Digest::SHA256.hexdigest(key2)
#Perform RIPEMD-160 hashing on the result of SHA-256 	
ripemd=Digest::RMD160.hexdigest(sha256.to_s)
#Add version byte in front of RIPEMD-160 hash (0x00 for Main Network) 
#Perform SHA-256 hash on the extended RIPEMD-160 result
sha256_2=Digest::SHA256.hexdigest("00#{ripemd.to_s}")
#Take the first 4 bytes of the second SHA-256 hash. This is the address checksum
checksum=sha256_2[0..8]
#Add the 4 checksum bytes from stage 7 at the end of extended RIPEMD-160 hash 
#from stage 4. This is the 25-byte binary Bitcoin Address. 
address="00#{ripemd}#{checksum}"
address=Base58.encode(address.to_i(16))
p "address: #{address}"
keys=Hash.new
keys['privkey']=private_key
keys['pubkey']= public_key_string
keys['pubaddress']=address
return keys	
end	


def create_transaction(privkey,pubkey,trans)
group = ECDSA::Group::Secp256k1
digest = Digest::SHA256.digest(trans)
signature = nil
while signature.nil?
  temp_key = 1 + SecureRandom.random_number(group.order - 1)
  signature = ECDSA.sign(group, privkey, digest, temp_key)
end
signature_der_string = ECDSA::Format::SignatureDerString.encode(signature)
p "signature string: #{signature_der_string}"
res=Hash.new
res['pubkey']=pubkey
res['signature_string']=signature_der_string
res['trans']=trans
return res
end


def validate_transaction(trans)	
pubkey=trans['pubkey']
signature_string=trans['signature_string']
trans=trans['trans']
group = ECDSA::Group::Secp256k1
digest = Digest::SHA256.digest(trans)
signature = ECDSA::Format::SignatureDerString.decode(signature_string)
public_key = ECDSA::Format::PointOctetString.decode(pubkey, group)
valid = ECDSA.valid_signature?(public_key, digest, signature)
puts "validion: #{valid}"
return valid
end

keys=generate_keys
trans=create_transaction(keys['privkey'],keys['pubkey'],'previoustransctionhash')
p trans['pubkey']
p trans['signature_string']

validate_transaction(trans)	
