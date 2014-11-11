
require 'openssl'
priv_alice= OpenSSL::PKey::RSA.new(1024)
pub_alice = priv_alice.public_key

priv_bob = OpenSSL::PKey::RSA.new(1024)
pub_bob = priv_bob.public_key


string = "Ruby rocks!"

encrypted1 = priv_alice.private_encrypt(string)
encrypted2 = pub_bob.public_encrypt(encrypted1)

decrypted2 = priv_bob.private_decrypt(encrypted2)
decrypted1 = pub_alice.public_decrypt(decrypted2)

puts decrypted1