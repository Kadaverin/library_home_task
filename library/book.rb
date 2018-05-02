class Book
    attr_reader :title, :author
    alias :name :title

    def initialize(title, author)
        raise ArgumentError unless (title.is_a? String) && (author.is_a? Author)
        @title, @author = title, author
    end

    def == (other) 
        return false unless other.is_a? Book
        @title == other.title && @author == other.author
    end

    def to_s
        "\"#{title}\", #{author.min_info}"
    end
end