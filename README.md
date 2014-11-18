rubychain
=========

Minimum viable blockchain implmentation using Ruby. 
I'm doing this as a personal voyage to understand the block chain better, and because I don't see other Ruby implemetations of blockchain technlogy out there(although I do see Python and Java courtesy of Ethereum). 
Public and private keys:
I actually started using RSA key pairs to begin with .I later went with Eliptical Curve for a number of reasons:
1. Bitcoin uses it(hate to be  a copycat...)
2. Shorter keys
3. Lower CPU and memory consumption
4. A handy ECDSA gem to make it easier

Using the ECDSA gem I created a key pair, encoding the public key as an octet encoded string and saving it away. 
I also took the x and y coordinates of the string and used them to create a condensed public address as follows:
'04' appended by the x coordinate then the y coordinate
1.Performed SHA-256 hashing on the result
2.Performed RIPEMD-160 hashing on the result of SHA-256 hash	
3.Add version byte in front of RIPEMD-160 hash (0x00 for Main Network) 
4.Perform SHA-256 hash on the extended RIPEMD-160 result
5.Take the first 4 bytes of the second SHA-256 hash. This is the address checksum
6.Add the 4 checksum bytes from stage 7 at the end of extended RIPEMD-160 hash from stage 4. 

This is the 25-byte binary Bitcoin Address. 


