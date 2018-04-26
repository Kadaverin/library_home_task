class Book 
    attr_reader :title, :author
    alias :name :title

    def initialize(title, author)
        @title, @author = title, author
    end

    def ==(other) 
        @title == other.title && @author == other.authoe
    end

    def to_s
        "\"#{title}\", #{author.name}"
    end
end