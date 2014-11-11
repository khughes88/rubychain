require 'ecdsa'
require 'json'
require 'digest'
require 'securerandom'

group = ECDSA::Group::Secp256k1
private_key="61420093381559807428299827838883798213175132518424280803803521434237838558367"
public_key_string="\x03^\xE4\t\x01\xDC\e\x13\xF1\xED\xCDb\x93\e\xD6\x0F\x84\x10\e\xF1\x19\x1E\xE2{6\xCB\xF19A\xB2\x7F\xBAM"
public_key = ECDSA::Format::PointOctetString.decode(public_key_string, group)


require 'digest'

trans=Hash.new
trans['input']="00000000000000000000000000000000000000000000"
trans['amount']=120000000000
trans['output']="asdfasdfasdfasdf"
trans=trans.to_json.to_s

message = trans
digest = Digest::SHA256.digest(message)
signature = nil
while signature.nil?
  temp_key = 1 + SecureRandom.random_number(group.order - 1)
  signature = ECDSA.sign(group, private_key, digest, temp_key)
end
puts 'signature: '
puts '  r: %#x' % signature.r
puts '  s: %#x' % signature.s

signature_der_string = ECDSA::Format::SignatureDerString.encode(signature)
signature = ECDSA::Format::SignatureDerString.decode(signature_der_string)

valid = ECDSA.valid_signature?(public_key, digest, signature)
puts "valid: #{valid}"