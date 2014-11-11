# To list available digests:
#p OpenSSL::Digest.constants
#keypair = OpenSSL::PKey::RSA.new(2048)
require "openssl"
require "json"

g_priv_k="-----BEGIN DSA PRIVATE KEY-----
MIH5AgEAAkEA9VtOLH1yepcabP4lCztkCdYlsGp5gheFQooaSh0gWeJ+fGGTHV/s
tzpVm+6f7i9xgfbJ6uw8XQLO5cIVZJjySwIVAMwWqP/TtI/UebZR9XnyCuvRgPZH
AkEA2cubHN62jW/MbLHjec5M2fjF9xT5GW9XaYqwDxwZ6Aj20+z62msjIE6Bctsn
T/1BS/yV/S+GRbmcX+di5zqYpAJBAJVODuy3KVa17/CZJm47wzKjv7E8XDc53sU0
M/TrKH1iWw0muDrzB8MO5YfG145tK1gTBVJWzxUyAc43bfivEHwCFAValSV3xdj8
mfdrU7/Q69n33A8Y-----END DSA PRIVATE KEY-----"
g_pub_k="-----BEGIN DSA PUBLIC KEY-----
MIHgAkEAlU4O7LcpVrXv8JkmbjvDMqO/sTxcNznexTQz9OsofWJbDSa4OvMHww7l
h8bXjm0rWBMFUlbPFTIBzjdt+K8QfAJBAPVbTix9cnqXGmz+JQs7ZAnWJbBqeYIX
hUKKGkodIFnifnxhkx1f7Lc6VZvun+4vcYH2yersPF0CzuXCFWSY8ksCFQDMFqj/
07SP1Hm2UfV58grr0YD2RwJBANnLmxzeto1vzGyx43nOTNn4xfcU+RlvV2mKsA8c
GegI9tPs+tprIyBOgXLbJ0/9QUv8lf0vhkW5nF/nYuc6mKQ=
-----END DSA PUBLIC KEY-----"
gods_private_key=OpenSSL::PKey::RSA.new(g_priv_k)
gods_public_key=OpenSSL::PKey::RSA.new(g_pub_k)

key = OpenSSL::PKey::EC.new('secp256k1')
p key

transaction="{'input':'0000000000000000000000000000000000000000000000000000000000000000', 'output1':'','output2':'','hashofprevious':'','amount':'','timestamp':''}"
p transaction.bytesize
gods_private_key

gods_signature = gods_private_key.private_encrypt(transaction)
p "gods signed transaction: #{gods_signature}"

string = gods_public_key.public_decrypt(gods_signature)
p "String as decrypted using god's public key: #{string}"


#previous transaction plus public key of sender





#p "signture #{signature}"
#########################
# Verify the signature #
#########################
# The public key is just a function of the private key. You can lose the
# public key. As long as you have the private key, you can just generate
# the public key again, it doesn't change.

# You can read the file from disk, you probably didn't have the keypair available post creation like we have in this example.
#pub_key = OpenSSL::PKey::RSA.new(File.read("/tmp/ruby-ssl-cheatsheet/our.pub"))
#p pub_key.verify(digest, signature, priv_key)
# => true
#p pub_key.verify(digest, signature, transaction + "altered")
# => false
#p pub_key.verify(digest, "altered" + signature, transaction)
# => false
