class Author < Human 
    attr_accessor :biography

    def initialize(name, birth_year, biography)
        @biography = biography
        super(name, birth_year)
    end

    def == (other)
        super &&
        @biography == other.biography 
    end

    def to_s 
        "#{self.min_info}, #{@biography}"
    end
end