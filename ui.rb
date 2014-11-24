require './transaction.rb'

Shoes.app do
	background "#eee"

	stack do
		 IO.foreach('/home/keith/rubychain/keys.txt') {|x| 
		x=x.to_json
		 para x[:address]
		 }
	end
end
			



	
