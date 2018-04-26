# $LOAD_PATH.unshift( File.join( File.dirname(__FILE__), 'library' ) )
$:.unshift File.dirname(__FILE__)
require 'faker'
require 'Human'


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
        @currentItemIndex = 0;
        @items = {};
    end
    
    def add_item (item) 
       
       class << item
            def id=(val)
                @id = val
            end

            def id
                @id 
            end
        end
         
         item.id = @currentItemIndex
         item.instance_eval('undef :id=')

        #  class << item 
        #      undef id= 
        #  end 

        @currentItemIndex += 1
        @items[item.id] = item
        item
    end

    def get_items_by_name (name)
        result_arr = []
        @items.each_value {|item| result_arr << item if item.name == name}
        return result_arr
    end

    def get_item_by_id (item_id) 
        @items[item.id]
    end

    def delete_item (item) 
        @items.delete(item.id)
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
    def to_s 
        books_str = ""
        @items.each_value { |book| books_str << " \"#{book.title}\" , #{book.author.name} \n" }
        books_str
    end
end

class AuthorsCatalog < Catalog 
    def get_author_bio (author_name)
        self.get_item_by_name(author_name).biography
    end
end

class ReadersCatalog < Catalog 
    def get_address_by_name (reader_name)
        # self.get_item_by_name(reader_name).address
    end

    def get_email_by_name (reader_name)
        # self.get_item_by_name(reader_name).email
    end
end

class OrdersCatalog 
    def initialize
        @orders = {}
    end

    def add_item(order)
        @orders[order.book.id] = order
    end

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
        existing_authors =  @authors.get_items_by_name(author)
        case existing_authors.size
            when 0
                author = new_author(author)
            when 1
                author = existing_authors[0]
            else 
             # узнать , какой именно автор имеется в виду и присвоить author 
        end
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
        books = @books.get_items_by_name(title)

        case books.size 
            when 0
                puts 'Автор не найден'
            when 1 
                puts "#{books.author.name}"
            else 
                puts "Несколько совпадений : "
                books.each { |book| print "#{book.author.name} | "}
                puts "\n"
        end
    end

    def print_to_file
    end

    def scan_from_file
    end

    def to_s 
        " #{ "_" * 50}\n Books : \n#{@books} "
    end
end


lib = Library.new

20.times { 
    lib.new_book(Faker::Book.title , Faker::Book.author ) 
    lib.new_reader(Faker::Name.name , Faker::Internet.free_email , Faker::Address.city , Faker::Address.street_name  , Faker::Number.between(1, 300))
    lib.new_author( Faker::Book.author , Faker::Lovecraft.paragraph)
}

# lib.show_author_of_book('Книга 1')

puts lib
