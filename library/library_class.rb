libdir = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'json'
require 'book'
require 'order'
require 'human'
require 'reader'
require 'author'
require 'library_catalogs'
require 'wrap_for_string_extension'

class Library
    using WrapForString

    def initialize
        @books   =  LibraryCatalogs::BooksCatalog.new
        @authors =  LibraryCatalogs::AuthorsCatalog.new
        @orders  =  LibraryCatalogs::OrdersCatalog.new
        @readers =  LibraryCatalogs::ReadersCatalog.new
    end

    def new_book(title, author)
        # chech if author already exist? Or , whatever. 
        book = Book.new(title, author)
        @books.add_item(book)
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

    def show_statistics
      orders_by_reader_id = @orders.get_hash_orders_ids_by_readers_ids
      orders_by_book_id = @orders.get_hash_orders_ids_by_books_ids

      readers_ids_by_num_of_orders =  orders_by_reader_id.keys.sort do |id1, id2| 
          orders_by_reader_id[id2].size <=> orders_by_reader_id[id1].size
      end
    
      books_ids_by_num_of_orders = orders_by_book_id.keys.sort do |id1, id2| 
           orders_by_book_id[id2].size <=>  orders_by_book_id[id1].size
      end

      reader = @readers.get_item_by_id( readers_ids_by_num_of_orders.first )
      puts '-' * 120
      puts "Made orders more than anyone :\n#{reader}\n#{ '-' * 120 }"
      puts "Three most popular books : \n"

      books_ids_by_num_of_orders[0..2].each_with_index do |id, i|
          book = @books.get_item_by_id(id) 
          num_of_orders = orders_by_book_id[id].size
          puts "#{i+1}. #{book} | total ordered : #{ num_of_orders }"
      end
      puts '-' * 120
    end


    def get_all_orders_arr
        @orders.get_all_items.values
    end

    def get_all_readers_arr
        @reders.get_all_items.values
    end

    def get_all_authors_arr
        @authors.get_all_items.values
    end

    def get_all_books_arr
        @books.get_all_items.values
    end

    def show_author_of_book(title)
        books = @books.get_items_by_name(title)
        # Book titles can match
        case books.size
            when 0
                puts 'Автор не найден'
            when 1 
                puts books.author.name
            else 
                puts 'Несколько совпадений : '
                books.each { |book| print "#{book.author.min_info} | " }
        end
    end

    def print_to_files
        # записываю текущее состояние приложения (id и отношения обьектов библиотеки)
        current_lib_state = {
            auth_id: @authors.get_all_ids,
            books_id: @books.get_all_ids,
            readers_id: @readers.get_all_ids,
            auth_of_book_id: self.get_all_books_arr.map {|book| book.author.id},
            b_and_r_orders_ids: self.get_all_orders_arr.map{ |order| { old_b_id: order.book.id, old_r_id:order.reader.id } }
        }
        File.open('data_store/lib_state.json', 'w') do |f|
            f.puts current_lib_state.to_json
        end
        # библиотека в текстовом представлении
        File.open('data_store/books.txt', 'w') do |f|
            f.puts @books
        end

        File.open('data_store/authors.txt', 'w') do |f|
            f.puts @authors
        end

        File.open('data_store/readers.txt', 'w') do |f|
            f.puts @readers
        end

        File.open('data_store/orders.txt', 'w') do |f|
            f.puts @orders
        end
    end
        # scan_from_file полностью восстанавливает состояние библотеки на момент ее последней записи.
        # То есть , связи между всеми обьектами библиотеки и сами коллекции этих обьектов.
        # old_lib_state - айдишки обьектов по порядку их расположения (добавления)
        # а также связи между обьектами (по id), такие как книга - автор или  заказ - книга и читатель ...
        # new_lib_state будет хранить проекцию старых айдишек на новые.
        # Поскольку при сканировании библиотеки из файлов все обьекты пересоздаются заново и
        # счетчики айдишек обнуляются , то могут возникнуть несоответсвия между старым состоянием и новым.
        # Например , если в процессе редактирования библиотеки ( работы программы ) из нее были удалены несколько книг,
        # у которых айдишки были 4 и 5 , то порядок номеров в старом состоянии библиотеки будет 1,2,3,6,7 ...
        # В то время как , в силу того , что при сканировании все пересоздается с нуля , в новом состоянии библиотеки 
        # книга с айди равным 6 станет четвертой книгой , 7 - пятой .. и т.д.(Id автоинкрементится) 
        # Выходит , что вся информация о заказах , в которых участвуют книги с айди от 4 и выше станет недействительной. 
        # Потому нужно проекция старого состояния в новое
    def scan_from_files
        old_lib_state = JSON.parse(File.read('data_store/lib_state.json'))
        new_lib_state = { new_b_id_by_old: {}, new_a_id_by_old: {}, new_r_id_by_old: {} }

        parse_authors(old_lib_state, new_lib_state)
        parsed_authors = @authors.get_all_items

        parse_readers(old_lib_state, new_lib_state)
        parsed_readers = @readers.get_all_items

        parse_books(old_lib_state, new_lib_state, parsed_authors)
        parsed_books = @books.get_all_items

        parse_orders(old_lib_state, new_lib_state, parsed_books, parsed_readers)
    end

        # дальше танцы с бубнами, чтобы распарсить библиотеку из txt. Лучше не смотреть..

    private def parse_readers(old_state, new_state)
        readers = File.read('data_store/readers.txt').split('-' * 120)
        readers.pop # после split последний элемент массива - пустая строка.Удаляем его

        readers.each_with_index do |reader,index| 
            name, birth, email, city, street, house = reader.split(', ')
            # обновляем информацию о состоянии. 
            old_r_id = old_state['readers_id'][index]
            new_state[:new_r_id_by_old][old_r_id] = index
            # создаем читателя в библиотеке
            new_reader(name.strip!, birth.to_i, email, city, street, house.to_i)
        end
    end

    private def parse_authors(old_state,new_state)
        authors = File.read('data_store/authors.txt').split('-' * 120)
        authors.pop
        authors.each_with_index do |author, index|
             parse_author_string(author)
             old_id =  old_state['auth_id'][index]
             new_state[:new_a_id_by_old][old_id] = index
        end
    end

    private def parse_author_string(auth)
        auth.lstrip!
        min_info,bio = auth.split("\n", 2)
        name, birth_year = min_info.split(', ')
        new_author(name, birth_year.to_i, bio.rstrip!)
    end

    private def parse_books(old_state, new_state, parsed_auth_by_id)
        books = File.read('data_store/books.txt').split('-' * 120)
        books.pop
        books.each_with_index do |book,index|
            title = book.scan(/^".*"/).first.gsub!(/["]/, '') # получаем название книги и обрезаем кавычки

            old_b_id = old_state['books_id'][index]
            old_auth_id = old_state['auth_id'][index]
            new_auth_id = new_state[:new_a_id_by_old][old_auth_id]
            author = parsed_auth_by_id[new_auth_id]
            new_state[:new_b_id_by_old][old_b_id] = index

            new_book(title,author)
        end
    end

    private def parse_orders(old_state, new_state, books_by_id , readers_by_id)
        orders = File.read('data_store/orders.txt').split('-' * 120)
        orders.pop
        orders.each_with_index do |order,index|
            order_date = Time.parse( order.split('Date :').last )
            old_r_id =  old_state['b_and_r_orders_ids'][index]['old_r_id']
            old_b_id = old_state['b_and_r_orders_ids'][index]['old_b_id']
            new_b_id = new_state[:new_b_id_by_old][old_b_id]
            new_r_id = new_state[:new_r_id_by_old][old_r_id]
            new_order(books_by_id[new_b_id], readers_by_id[new_r_id], order_date)
        end
    end

    def to_s 
        'BOOKS:'.center(120)   + "\n#{@books}"   + '-' * 120 + "\n" +
        'AUTHORS:'.center(120) + "\n#{@authors}" + '-' * 120 + "\n" +
        'READERS:'.center(120) + "\n#{@readers}" + '-' * 120 + "\n" +
        'ORDERS:'.center(120)  + "\n#{@orders}"  + '-' * 120 + "\n"
    end
end