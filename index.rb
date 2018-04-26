libdir = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'library/library_class'
require 'fake_data_helper.rb'

lib = Library.new

full_by_fake_info(lib)

lib.show_statistics