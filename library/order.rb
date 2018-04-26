class Order 
    attr_reader :book, :reader, :date

    def initialize(book , reader , date)
        @book, @reader, @date = book, reader, date
    end

    def ==(other)
        @book == other.book && @reader == other.reader && @date == other.date
    end

    def to_s 
        "Book : #{@book} | Reader : #{@reader} | Date : #{@date}"
    end
end 