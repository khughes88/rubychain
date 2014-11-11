
require 'ecdsa'
require 'securerandom'
group = ECDSA::Group::Secp256k1
private_key = 1 + SecureRandom.random_number(group.order - 1)
puts  private_key
public_key = group.generator.multiply_by_scalar(private_key)
#puts 'public key: '
#puts '  x: %#x' % public_key.x
#puts '  y: %#x' % public_key.y

 #= ECDSA::Format::PointOctetString.encode(public_key, compression: true)
public_key_string= "04#{public_key.x}#{public_key.y}"
require 'digest/md5'
require 'digest'
pub_hash=Digest::SHA256.new << public_key_string
p pub_hash

#~ public_key = ECDSA::Format::PointOctetString.decode(public_key_string, group)

#~ require 'digest'
#~ message = 'ECDSA is cooldafsgdfgsdfgsdfgsdfgsdfgsdfgsdfgsdfgsdfg45634563456345634563456345634.'
#~ digest = Digest::SHA256.digest(message)
#~ signature = nil
#~ while signature.nil?
  #~ temp_key = 1 + SecureRandom.random_number(group.order - 1)
  #~ signature = ECDSA.sign(group, private_key, digest, temp_key)
#~ end
#~ #puts 'signature: '
#~ #puts '  r: %#x' % signature.r
#~ #puts '  s: %#x' % signature.s


#~ signature_der_string = ECDSA::Format::SignatureDerString.encode(signature)
#~ p signature_der_string.bytesize


#~ valid = ECDSA.valid_signature?(public_key, digest, signature)
#~ puts "valid: #{valid}"