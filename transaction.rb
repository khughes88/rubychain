require 'ecdsa'
require 'json'
require 'digest'
require 'securerandom'

def generate_keys
group = ECDSA::Group::Secp256k1
private_key = 1 + SecureRandom.random_number(group.order - 1)
puts  private_key
public_key = group.generator.multiply_by_scalar(private_key)
public_key_string=ECDSA::Format::PointOctetString.encode(public_key, compression: true)
p public_key_string
keys=Hash.new
keys['privkey']=private_key
keys['pubkey']= public_key_string
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
puts "valid: #{valid}"
return valid
end

keys=generate_keys
trans=create_transaction(keys['privkey'],keys['pubkey'],'previoustransctionhash')
p trans['pubkey']
p trans['signature_string']

validate_transaction(trans)	
