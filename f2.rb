class Human
   attr_reader :name

   def initialize (name) 
       @name = name
   end
end

class Author < Human 
    attr_accessor :biography

    def initialize(name, biography)
        @biography = biography
        super(name)
    end
end

class Reader < Human
    attr_reader :email, :city, :street, :house

    def initialize(name, email, city, street, house)
        @email, @city, @street, @house =  email, city, street, house
        super(name)
    end

    def address 
        "#{city}, #{street}, #{email}"
    end
end

class Book 
    attr_reader :title, :author
    alias :name :title

    def initialize(title, author)
        @title, @author = title, author
    end
end

class Order 
    attr_reader :book, :reader, :date

    def initialize(book , reader , date)
        @book, @reader, @date = book, reader, date
    end
end 

class Catalog 
    def initialize
        @items = {};
    end
    
    def add_item (item) 
        @items[item.name] = item
        item
    end

    def get_item_by_name (name)
        @items[name]
    end
    def delete_item (item) 
        @items.delete(item.name)
    end

    def to_s
        "#{@items}"
    end
end

class BooksCatalog < Catalog 

    def get_books_by_author
    end

    def get_statistics
    end
end

class AuthorsCatalog < Catalog 
    def get_author_bio (author_name)
        self.get_item_by_name(author_name).biography
    end
end

class ReadersCatalog < Catalog 
    def get_address_by_name (reader_name)
        self.get_item_by_name(reader_name).address
    end

    def get_email_by_name (reader_name)
        self.get_item_by_name(reader_name).email
    end
end

class OrdersCatalog < Catalog

    def get_statistics
    end
end


class Library 
    def initialize 
        @books = BooksCatalog.new
        @authors = AuthorsCatalog.new
        @orders = OrdersCatalog.new
        @readers = ReadersCatalog.new
    end

    def new_book(title, author)
        new_author(author) unless @authors.get_item_by_name(author)
        book = Book.new(title, author)
        @books.add_item (book)
    end

    def new_order(book , reader)
        order = Order.new(book , reader)
        @orders.add_item(order)
    end

    def new_author(name, biography="Биография пока пуста")
        author = Author.new(name, biography)
        @authors.add_item(author)
    end

    def new_reader(name, email, city, street, house) 
        reader = Reader.new(name, email, city, street, house)
        @readers.add_item(reader)
    end

    def show_author_of_book (title)
        book = @books.get_item_by_name(title)
        puts book ? book.author : 'Not found'
       
    end

    def print_to_file
    end

    def scan_from_file
    end

    def to_s 
        "Books : #{@books} \n Authors : #{@authors} \n Readers : #{@readers}"
    end
end


lib = Library.new

lib.new_book("Книга 1" , "Автор 1" );
lib.new_book("Книга 2" ,"Автор 2" );
lib.new_book("Книга 3" , "Автор 3" );
lib.new_book("Книга 4" , "Автор 1" );
lib.show_author_of_book('Книга 4')
puts lib
