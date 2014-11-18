require 'pstore'


def dataput 
db = PStore.new("blocks.dat")
db.transaction do
db[:fathers] =[]
a_father = { "father" => "Bob", "age" =>  40 }
 db[:fathers] << a_father
a_father = { "father" => "David", "age" =>  32 }
 db[:fathers]<< a_father
a_father = { "father" => "Batman", "age" =>  50 }
 db[:fathers]<< a_father 
end
end  
#dataput
db = PStore.new("blocks.dat")
  db.transaction do  
	  a_father = { "father" => "keith", "age" =>  50 }
 db[:fathers]<< a_father 
  # p db[:fathers].select {|father| father["age"] > 35 }
  p db[:fathers]
    end