class Human
   attr_reader :name ,:birth_year

   def initialize (name ,birth_year) 
       @name , @birth_year = name , birth_year
   end

   def min_info 
       "#{@name}, #{@birth_year}"
   end
   
   def == (other)
       @name == other.name && @birth_year == other.birth_year
   end
end