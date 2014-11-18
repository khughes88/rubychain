#rubychain
=========

##Minimum viable blockchain implmentation using Ruby. 
I'm doing this as a personal voyage to understand the block chain better, and because I don't see other Ruby implemetations of blockchain technlogy out there(although I do see Python and Java courtesy of Ethereum). 
###Public and private keys:
I actually started using RSA key pairs to begin with .I later went with Eliptical Curve for a number of reasons:
* Bitcoin uses it(hate to be  a copycat...)
* Shorter keys
* Lower CPU and memory consumption
* A handy ECDSA gem to make it easier

Using the ECDSA gem I created a key pair, encoding the public key as an octet encoded string and saving it away. 
I also took the x and y coordinates of the string and used them to create a condensed public address as follows:
'04' appended by the x coordinate then the y coordinate
* Performed SHA-256 hashing on the result
* Performed RIPEMD-160 hashing on the result of SHA-256 hash	
* Add version byte in front of RIPEMD-160 hash (0x00 for Main Network) 
* Perform SHA-256 hash on the extended RIPEMD-160 result
* Take the first 4 bytes of the second SHA-256 hash. This is the address checksum
* Add the 4 checksum bytes from stage 7 at the end of extended RIPEMD-160 hash from stage 4. 

This is the 25-byte binary Bitcoin Address. 

###User Interface
18/11/2014: I'm starting with Shoes on this. So far so good. learning how to package all of this up will mean a lot. I'll figure that out at a later date 

###Data store
18/11/2014: I'm considering using PStore to get this started.
