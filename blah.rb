require 'openssl'


# Monkey patch round bug
class OpenSSL::PKey::EC
def private?
return self.private_key?
end
end unless ARGV[0] != 'PATCH'

data = 'Sign me!'
digest = OpenSSL::Digest::SHA256.new

key = OpenSSL::PKey::EC.new('secp256k1')
key.generate_key
private_str= key.private_key.to_s
public_str= key.public_key.to_bn.to_s

p private_str
p public_str
p public_str.to_i.to_s(16)

signature = key.sign(digest, data)
p signature






