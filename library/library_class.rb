# $:.unshift File.dirname(__FILE__)
libdir = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'book'
require 'order'
require 'human'
require 'reader'
require 'author'
require 'library_catalogs'

class Library 

    def initialize 
        @books   =  LibraryCatalogs::BooksCatalog.new
        @authors =  LibraryCatalogs::AuthorsCatalog.new
        @orders  =  LibraryCatalogs::OrdersCatalog.new
        @readers =  LibraryCatalogs::ReadersCatalog.new
    end

    def new_book(title, author)
        #chech if author not exist
        book = Book.new(title, author)
        @books.add_item (book)
    end

    def new_order(book , reader, date)
        order = Order.new(book , reader, date)
        @orders.add_item(order)
    end

    def new_author(name, birth_year, biography)
        author = Author.new(name, birth_year, biography)
        @authors.add_item(author)
    end

    def new_reader(name, birth_year, email, city, street, house) 
        reader = Reader.new(name, birth_year, email, city, street, house)
        @readers.add_item(reader)
    end

    def show_all_orders
        @orders.get_all_items
    end

    def show_statistics
      orders_by_reader_id = @orders.get_hash_orders_ids_by_readers_ids
      orders_by_book_id = @orders.get_hash_orders_ids_by_books_ids
    
      books_ids_by_num_of_orders = orders_by_book_id.keys.sort do |id1, id2| 
           orders_by_book_id[id2].size <=>  orders_by_book_id[id1].size
      end

      readers_ids_by_num_of_orders =  orders_by_reader_id.keys.sort do |id1, id2| 
          orders_by_reader_id[id2].size <=> orders_by_reader_id[id1].size
      end

      reader = @readers.get_item_by_id( readers_ids_by_num_of_orders.first )

      puts "-" * 100
      puts "Made orders more than anyone :\n#{reader}\n#{ "-" * 100}"
      puts "Three most popular books : \n"

      books_ids_by_num_of_orders[0..2].each_with_index do |id, i| 
          book = @books.get_item_by_id(id) 
          num_of_orders = orders_by_book_id[id].size

          puts "#{i+1}. #{book} | total ordered : #{num_of_orders }"
      end
      puts "-" * 100

          #   num_of_readers_order_by_id = {}
    #   orders_by_readers_id.each do |k,v| 
    #        num_of_readers_order_by_id[k] = v.size
    #   end
        #   puts readers_ids_by_num_of_orders 
    #   puts orders_by_reader_id 
    #   puts "\n"
    #   puts num_of_readers_order_by_id
    
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
                books.each { |book| print "#{book.author.min_info} | "}
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


# puts last_order
# lib.show_author_of_book('Книга 1')
#lib.show_all_orders
# puts lib
