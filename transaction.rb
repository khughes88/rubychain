require 'rubygems'

require 'json'
require 'digest'
require 'securerandom'
require 'base58'
require 'ecdsa'
require 'kirbybase'
require 'openssl'


def sha256(hex)
Digest::SHA256.hexdigest([hex].pack("H*"))
end

def hash160_to_p2sh_address(hex)
encode_address hex, p2sh_version
end
def encode_address(hex, version)
hex = version + hex
encode_base58(hex + checksum(hex))
end

def pubkeys_to_p2sh_multisig_address(m, *pubkeys)
redeem_script = Bitcoin::Script.to_p2sh_multisig_script(m, *pubkeys).last
return Bitcoin.hash160_to_p2sh_address(Bitcoin.hash160(redeem_script.hth)), redeem_script
end
def int_to_base58(int_val, leading_zero_bytes=0)
alpha = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
base58_val, base = '', alpha.size
while int_val > 0
int_val, remainder = int_val.divmod(base)
base58_val = alpha[remainder] + base58_val
end
base58_val
end
def base58_to_int(base58_val)
alpha = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
int_val, base = 0, alpha.size
base58_val.reverse.each_char.with_index do |char,index|
raise ArgumentError, 'Value not a valid Base58 String.' unless char_index = alpha.index(char)
int_val += char_index*(base**index)
end
int_val
end
def encode_base58(hex)
leading_zero_bytes = (hex.match(/^([0]+)/) ? $1 : '').size / 2
("1"*leading_zero_bytes) + int_to_base58( hex.to_i(16) )
end
def decode_base58(base58_val)
s = base58_to_int(base58_val).to_s(16); s = (s.bytesize.odd? ? '0'+s : s)
s = '' if s == '00'
leading_zero_bytes = (base58_val.match(/^([1]+)/) ? $1 : '').size
s = ("00"*leading_zero_bytes) + s if leading_zero_bytes > 0
s
end
#alias_method :base58_to_hex, :decode_base58
# target compact bits (int) to bignum hex
def decode_compact_bits(bits)
bytes = Array.new(size=((bits >> 24) & 255), 0)
bytes[0] = (bits >> 16) & 0x7f if size >= 1
bytes[1] = (bits >> 8) & 255 if size >= 2
bytes[2] = (bits ) & 255 if size >= 3
target = bytes.pack("C*").unpack("H*")[0].rjust(64, '0')
# Bit number 24 represents the sign
if (bits & 0x00800000) != 0
"-" + target
else
target
end
end
# target bignum hex to compact bits (int)
def encode_compact_bits(target)
bytes = OpenSSL::BN.new(target, 16).to_mpi
size = bytes.size - 4
nbits = size << 24
nbits |= (bytes[4] << 16) if size >= 1
nbits |= (bytes[5] << 8) if size >= 2
nbits |= (bytes[6] ) if size >= 3
nbits
end
def decode_target(target_bits)
case target_bits
when Fixnum
[ decode_compact_bits(target_bits).to_i(16), target_bits ]
when String
[ target_bits.to_i(16), encode_compact_bits(target_bits) ]
end
end


#----------------------------------------------------------------
def checksum(hex)
b = [hex].pack("H*") # unpack hex
Digest::SHA256.hexdigest( Digest::SHA256.digest(b) )[0...8]
end

# hash160 is a 20 bytes (160bits) rmd610-sha256 hexdigest.
def hash160(hex)
bytes = [hex].pack("H*")
Digest::RMD160.hexdigest Digest::SHA256.digest(bytes)
end

def hash160_to_address(hex)
address_version="00"	
encode_address hex, address_version
end


def pubkey_to_address(pubkey)
hash160_to_address( hash160(pubkey) )
end

def bitcoin_elliptic_curve
::OpenSSL::PKey::EC.new("secp256k1")
end

def generate_key
key = bitcoin_elliptic_curve.generate_key
#p key
#inspect_key( key )
end

def generate_address
prvkey, pubkey = generate_key
p pubkey_to_address(pubkey)
#p prvkey, pubkey, 
p hash160(pubkey) 
end

generate_address



#----------------------------------------------------------------
# hash160 is a 20 bytes (160bits) rmd610-sha256 hexdigest.
def hash160(hex)
bytes = [hex].pack("H*")
Digest::RMD160.hexdigest Digest::SHA256.digest(bytes)
end

def inspect_key(key)
[ key.private_key_hex, key.public_key_hex ]
end

def bitcoin_hash(hex)
Digest::SHA256.digest(
Digest::SHA256.digest( [hex].pack("H*").reverse )
).reverse.bth
end
def bitcoin_byte_hash(bytes)
Digest::SHA256.digest(Digest::SHA256.digest(bytes))
end
def bitcoin_mrkl(a, b); bitcoin_hash(b + a); end
def block_hash(prev_block, mrkl_root, time, bits, nonce, ver)
h = "%08x%08x%08x%064s%064s%08x" %
[nonce, bits, time, mrkl_root, prev_block, ver]
bitcoin_hash(h)
end
def litecoin_hash(hex)
bytes = [hex].pack("H*").reverse
begin
require "scrypt" unless defined?(::SCrypt)
hash = SCrypt::Engine.__sc_crypt(bytes, bytes, 1024, 1, 1, 32)
rescue LoadError
hash = Litecoin::Scrypt.scrypt_1024_1_1_256_sp(bytes)
end
hash.reverse.unpack("H*")[0]
end
def block_scrypt_hash(prev_block, mrkl_root, time, bits, nonce, ver)
h = "%08x%08x%08x%064s%064s%08x" %
[nonce, bits, time, mrkl_root, prev_block, ver]
litecoin_hash(h)
end
# get merkle tree for given +tx+ list.
def hash_mrkl_tree(tx)
return [nil] if tx != tx.uniq
chunks = [ tx.dup ]
while chunks.last.size >= 2
chunks << chunks.last.each_slice(2).map {|a, b| bitcoin_mrkl( a, b || a ) }
end
chunks.flatten
end
# get merkle branch connecting given +target+ to the merkle root of +tx+ list
def hash_mrkl_branch(tx, target)
return [ nil ] if tx != tx.uniq
branch, chunks = [], [ tx.dup ]
while chunks.last.size >= 2
chunks << chunks.last.each_slice(2).map {|a, b|
hash = bitcoin_mrkl( a, b || a )
next hash unless [a, b].include?(target)
branch << (a == target ? (b || a) : a)
target = hash
}
end
branch
end
# get merkle root from +branch+ and +target+.
def mrkl_branch_root(branch, target, idx)
branch.each do |hash|
a, b = *( idx & 1 == 0 ? [target, hash] : [hash, target] )
idx >>= 1;
target = bitcoin_mrkl( a, b )
end
target
end
def sign_data(key, data)
key.dsa_sign_asn1(data)
end
def verify_signature(hash, signature, public_key)
key = bitcoin_elliptic_curve
key.public_key = ::OpenSSL::PKey::EC::Point.from_hex(key.group, public_key)
key.dsa_verify_asn1(hash, signature)
rescue OpenSSL::PKey::ECError, OpenSSL::PKey::EC::Point::Error
false
end
def open_key(private_key, public_key=nil)
key = bitcoin_elliptic_curve
key.private_key = ::OpenSSL::BN.from_hex(private_key)
public_key = regenerate_public_key(private_key) unless public_key
key.public_key = ::OpenSSL::PKey::EC::Point.from_hex(key.group, public_key)
key
end
def regenerate_public_key(private_key)
OpenSSL_EC.regenerate_key(private_key)[1]
end
def bitcoin_signed_message_hash(message)
# TODO: this will fail horribly on messages with len > 255. It's a cheap implementation of Bitcoin's CDataStream.
data = "\x18Bitcoin Signed Message:\n" + [message.bytesize].pack("C") + message
Digest::SHA256.digest(Digest::SHA256.digest(data))
end
def sign_message(private_key_hex, public_key_hex, message)
hash = bitcoin_signed_message_hash(message)
signature = OpenSSL_EC.sign_compact(hash, private_key_hex, public_key_hex)
{ 'address' => pubkey_to_address(public_key_hex), 'message' => message, 'signature' => [ signature ].pack("m0") }
end
def verify_message(address, signature, message)
hash = bitcoin_signed_message_hash(message)
signature = signature.unpack("m0")[0] rescue nil # decode base64
raise "invalid address" unless valid_address?(address)
raise "malformed base64 encoding" unless signature
raise "malformed signature" unless signature.bytesize == 65
pubkey = OpenSSL_EC.recover_compact(hash, signature)
pubkey_to_address(pubkey) == address if pubkey
rescue => ex
p [ex.message, ex.backtrace]; false
end


#class PKey::EC
	def private_key_hex; private_key.to_hex.rjust(64, '0'); end
	def public_key_hex; public_key.to_hex.rjust(130, '0'); end
	def pubkey_compressed?; public_key.group.point_conversion_form == :compressed; end
#end
#class PKey::EC::Point
	def self.from_hex(group, hex)
	new(group, BN.from_hex(hex))
	end
	def to_hex; to_bn.to_hex; end
	def self.bn2mpi(hex) BN.from_hex(hex).to_mpi; end

#end

def generate_keys2
p generate_address	
end


def generate_keys
group = ECDSA::Group::Secp256k1
private_key = 1 + SecureRandom.random_number(group.order - 1)
p  "new private key:  #{private_key.to_s}"
public_key = group.generator.multiply_by_scalar(private_key)
public_key_string=ECDSA::Format::PointOctetString.encode(public_key)
key2="04#{public_key.x}#{public_key}"
p "new public key:  #{public_key_string}"
p public_key_string.to_s
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
p "address: #{address.to_s}"
keys=Hash.new
keys['privkey']=private_key.to_s.encode('UTF-8')
keys['pubkey']= public_key_string.to_s.encode('UTF-8',:invalid=>:replace, :undef=>:replace)
keys['pubaddress']=address.to_s.encode('UTF-8')

p keys

keys_json=keys.to_json.gsub("\\","")
p keys_json
open('./keys.txt','a') { |f|
f<<keys_json
}
#return keys

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
#generate_keys
#msg=''
#ile.open('./keys.txt'){|f|msg=f.readline.to_json}
generate_key
puts "--------"
#msg=JSON.parse(msg)
#puts msg[:privkey]
#trans=create_transaction(keys['privkey'],keys['pubkey'],'previoustransctionhash')
#p trans['pubkey']
#p trans['signature_string']

#validate_transaction(trans)	
