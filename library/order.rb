class Order
    attr_reader :book, :reader, :date

    def initialize(book, reader, date)
        raise ArgumentError unless (book.is_a? Book) && (reader.is_a? Reader)
        @book, @reader, @date = book, reader, date
    end

    def ==(other)
        return false unless other.is_a? Order
        @book == other.book && @reader == other.reader && @date == other.date
    end

    def to_s 
        "Book : #{@book} | Reader : #{@reader.min_info} | Date : #{@date}"
    end
end
