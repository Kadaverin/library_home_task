class Reader < Human
    attr_reader :email, :city, :street, :house

    def initialize(name, birth_year ,email, city, street, house)
        @email, @city, @street, @house =  email, city, street, house
        super(name, birth_year)
    end

    def address 
        "#{city}, #{street}, #{house}"
    end

    def == (other)
       super &&
       @email == other.email &&
       @addres == other.address 
    end

    def to_s
        "#{self.min_info} | Email : #{email} | Address : #{address}"
    end
end
