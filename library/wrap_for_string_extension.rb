
# Реализовал метод wrap для класса String. 
# Делает перенос слов в строке, если трока длиннее col символов

module WrapForString
    refine String do 
       def wrap(col = 120)
          gsub(/(.{1,#{col}})( +|$\n?)|(.{1,#{col}})/, "\\1\\3\n")
       end
    end
end
