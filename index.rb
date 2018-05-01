
require_relative 'library/library_class'
require_relative 'fake_data_helper.rb'

lib = Library.new
# написал, чтобы генерировать случайное начальное состояние библиотеки
# full_by_fake_info(lib)

lib.scan_from_files

# lib.print_to_files
lib.show_statistics
puts 'Look in data_store folder to be sure in it'

