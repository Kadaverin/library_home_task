module LibraryCatalogs

    class Catalog 
        def initialize
            @currentItemIndex = 0;
            @items = {};
        end 
        
        def add_item (item) 
    
            item.instance_variable_set(:@id , @currentItemIndex)
            item.instance_eval("class << item \n attr_reader :id \n end")

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
            @items[item_id]
        end

        def delete_item (item) 
            @items.delete(item.id)
        end

        def get_all_items
            @items
        end

        def to_s
            "#{@items}"
        end
    end

    class BooksCatalog < Catalog 

        def get_books_by_author
        end

        def to_s 
            books_str = ""
            @items.each_value { |book| books_str << " \"#{book.title}\" , #{book.author.name} \n" }
            books_str
        end
    end

    class AuthorsCatalog < Catalog 
        def get_author_bio (author_name)
            # self.get_item_by_name(author_name).biography
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

    class OrdersCatalog < Catalog
        
        def get_hash_orders_ids_by_readers_ids
            res_hash = Hash.new()
                @items.values.each do |order|
                    res_hash[order.reader.id] ||= [] 
                    res_hash[order.reader.id].push(order.id)
                end
          res_hash
        end

        def get_hash_orders_ids_by_books_ids
            res_hash = Hash.new()
                @items.values.each do |order|
                    res_hash[order.book.id] ||= [] 
                    res_hash[order.book.id].push(order.id)
                end
          res_hash
        end
    end
end