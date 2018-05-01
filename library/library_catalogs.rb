require 'wrap_for_string_extension'

module LibraryCatalogs
    # Каталог делает общие операции , далее идут специализации : книжный каталог, каталог заказов , авторов и читателей
    # Они будут выполнять более специализированные действия : найти email по имени читателя , выбор интересующего автора и т.д.

    class Catalog 
      using WrapForString

        def initialize
            @currentItemIndex = 0;
            @items = {};
        end 
        
        def add_item (item) 
            # Индексирую item - добавляю айдишку
            item.instance_variable_set(:@id , @currentItemIndex)
            item.instance_eval("class << item \n attr_reader :id \n end")

            @currentItemIndex += 1
            @items[item.id] = item
            item
        end

        def get_items_by_name (name)
            # совпадений по "имени" или названию может быть много
            result_arr = []
            @items.each_value {|item| result_arr << item if item.name == name}
            return result_arr
        end

        def get_item_by_id (item_id) 
            @items[item_id]
        end

        def delete_item (item) 
            @items.delete(item.id)
        end

        def get_all_items
            @items
        end

        def update_item (updated_item)
            @items[ updated_item.id ] = updated_item
        end

        def get_all_ids
            @items.keys
        end

        def to_s
            @items.values.inject('') {|str, item| str <<  "#{item}\n#{'-' * 120}\n".wrap}
        end
    end

    class OrdersCatalog < Catalog

        def get_hash_orders_ids_by_readers_ids
            res_hash = {}
                @items.values.each do |order|
                    res_hash[order.reader.id] ||= [] 
                    res_hash[order.reader.id].push(order.id)
                end
          res_hash
        end

        def get_hash_orders_ids_by_books_ids
            res_hash = {}
                @items.values.each do |order|
                    res_hash[order.book.id] ||= [] 
                    res_hash[order.book.id].push(order.id)
                end
          res_hash
        end
    end

    class BooksCatalog < Catalog 

        def get_books_by_author
        end
        # and other stuf like this
    end

    class AuthorsCatalog < Catalog 
        def get_author_bio (author_name)
        end
    end

    class ReadersCatalog < Catalog 
        def get_address_by_name (reader_name)
        end

        def get_email_by_name (reader_name)
        end
    end
end
