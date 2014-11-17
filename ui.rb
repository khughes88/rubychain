require './transaction.rb'

Shoes.app(width: 400, height: 100) { 
@new=button "New address" 
@note = para "-"
	@new.click{
	@note.replace generate_keys['pubaddress']
	}
}