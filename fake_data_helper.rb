require 'faker'
require 'json'

def time_rand from = 0.0, to = Time.now
  Time.at(from + rand * (to.to_f - from.to_f))
end

def full_by_fake_info (lib )

    file = File.read('./data_store/books.json')
    books_hashs_arr = JSON.parse(file)
    
    books = []
    readers = []
    
    40.times do |i| 
        title = books_hashs_arr[i]['title']
        published_in = books_hashs_arr[i]['year']
        author_name =  books_hashs_arr[i]['author']
        author_birth_year = published_in - rand(20..60)
        
        author = lib.new_author( 
                                 author_name, author_birth_year, 
                                 Faker::Lovecraft.paragraph         #bio
                               )
        reader = lib.new_reader(
                                 Faker::Name.name ,                 
                                 2018 - rand(18..80),               #birth
                                 Faker::Internet.free_email,
                                 Faker::Address.city , 
                                 Faker::Address.street_name,
                                 Faker::Number.between(1, 300)      #house
                                )
        book   = lib.new_book(title , author ) 
        books << book
        readers << reader
    end

    1600.times do 
        rand_reader = readers[ rand(0...readers.size) ]
        rand_book = books[ rand(0...books.size) ]
        rand_date = time_rand (Time.local(2015, 1, 1) )
        lib.new_order(rand_book ,rand_reader, rand_date)
    end
end