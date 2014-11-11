require 'openssl'

key = OpenSSL::PKey::EC.new('secp256k1')
key.generate_key
p key.private_key
p key.public_key.to_text


