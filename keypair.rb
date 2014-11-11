# To list available digests:
#p OpenSSL::Digest.constants
#keypair = OpenSSL::PKey::RSA.new(2048)
require "openssl"
require "json"
#priv_key = rand(115792089237316195423570985008687907852837564279074904382605163141518161494337).to_s
a_priv_k="-----BEGIN RSA PRIVATE KEY-----\n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\n-----END RSA PRIVATE KEY-----\n"
a_pub_k="-----BEGIN PUBLIC KEY-----\nMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEApXLQcv3k57hyoHWSlWf3\naJv7HQOhJxI5qzjoFu66PrBTttpsJqGTPHGT8Gh+AhhjQ1eYMbSeSUoMEUdrtz4H\nlfxJNr3hc6BOFeYProlzNYZMq6c71GB+dURoxYGygZ7UMrRpYTc9PjSdZrAX8B3v\nhA7HtYeoAAmcgAjRiw4dWDOcs7W8xDQR7f8fRhhSczMUmet/E4YJ/sN4p+LvNfx+\nUh+LO9OIwkU/yeZAJ4R2Wlp5+MIj7WgOpAcT97lYlkkMbkNjf8T6KTLdgEtTfPii\nk6lM4fAt5hZgIyn1Y10VPvb+Zc+Mfkr7bmIHbkIxXBH5xMOP5O+77eqILtVJJ+JP\nusk/IN4J5SLS79KFSVRXPb6+eolk70qSlLkqwJeU3EvAnHz1xzXTe7JPcIiO1Jur\nqzGxka5HtyMb5G+IQHWKdD0YIM0lWfYWi+TNw1iXBC7CsVca4kC4DeCSTWXdAht+\n7KJrXSrE4Kl0MYnkFifuuCGrGyqE/kmDooAg9FGb4ifKadWhmQuCtVjWlR9lPavR\ns6JmHgyaR5xfhZUG6QdkmYiVx8ona2pjnS86p7Bkyrdzz7d9iHxBa5XMYR0QGgSK\n3PWoxkLkSV+ibwJ7D+mgF90tndYXXY+9ePDiPFvYXoX7nZZip2UZaT2rI1ycond0\n5i98g/9K14FZIlgKd6HmSy0CAwEAAQ==\n-----END PUBLIC KEY-----\n"
alices_private_key=OpenSSL::PKey::RSA.new(a_priv_k)
alices_public_key=OpenSSL::PKey::RSA.new(a_pub_k)
bobs_private_key="-----BEGIN RSA PRIVATE KEY-----\n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\n-----END RSA PRIVATE KEY-----\n"
bobs_pub_key="-----BEGIN PUBLIC KEY-----\nMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAom/pZS9A7PJHEBcSFDqs\nwgGDPkG86Ui9x/akt2NxV+RgefowkFfsPBhblxsQSp1u8Vu95uNyAr6ynV/ugVb0\nKMys1dUPmQhj+e4glUoxeZQLa8MF1alVFYhikJtCgeJlJSbSHhggfLD0dHY4e0zS\niwHYXJTvNZPqd95KwJXWN9or/IHYKKQqAZUTYT1SSeAWfjQ8Vw088/n9qzVp0Vdi\noGYdB0BFjbx8i8iJiPzB5raNe4EuoG2x4wCUVf+jXeHJvW0wbnKwF37a1odM8EpG\nAeQcmWJmng5wLmTZfAUJKDcKp17gcf5ak9cARfsxiwCea3XrKK/TlH4UnrMZSChe\nzU4zEBnikUvBqCtuzFvknvqKEcHwvG9Nng7x0ry050TjE9Zd50ZKZ/vvRtSMhAYn\nCzkctcjCFObgL978+VflhBoTVivIPWRdH7sAK8OcUQzUtIP7PcXu0kfne4BOCE4T\nd//QvYsBnIK4Z/fRpayZEigybIVsCPllth6h6YQDNMQUMre/JGx92TFRDP9H32lb\nzT/Jzb1WONiIpLGAYMZ7lxCjwrNDq87kQO63giuW5LdtM4KxQ+N+etB0L3cRSCKp\nDxBKeuj0L80jjjoFCymqXIzoPuM7AibdfTN3UaV2X3yuTN4C3X08f/18MU5wKYNI\neAOBqT3HQLovPzFG3rW+a4MCAwEAAQ==\n-----END PUBLIC KEY-----\n"


digest = OpenSSL::Digest::SHA256.new
#alices_private_key= OpenSSL::PKey::RSA.new(2048)
p "Alices private key #{alices_private_key}"
#alices_pub_key = alices_private_key.public_key
p "Alices public key #{alices_public_key}"

#digest = OpenSSL::Digest::SHA256.new
#bobs_private_key= OpenSSL::PKey::RSA.new(2048)
p "Bobs private key #{bobs_private_key}"
#bobs_pub_key = bobs_private_key.public_key
p "Bobs public key #{bobs_pub_key}"

transaction=trans="{'public_key':,'input':'', 'output1':'','output2':'','hashofprevious':'','amount':'','timestamp':''}"



alices_signature = alices_private_key.private_encrypt(transaction)
p "Alices signed transaction: #{alices_signature}"

string = alices_public_key.public_decrypt(alices_signature)
p "String as decrypted using alice's public key: #{string}"


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
