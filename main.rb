APP_ROOT = File.expand_path(File.dirname(__FILE__))




require_relative 'tree'
require_relative 'file_reader'
require_relative 'tree_to_html'


puts "========================".center(60)
puts ""
puts "HTML REFORMATOR".center(60)
puts ''
puts "========================".center(60)

puts 'What HTML file do you want to use?'
puts 'Note: Please provide the full path'
puts 'unless the file is in this folder.'
print '> '
file_name = gets.chomp

until file_name.include?('html')
  puts 'Please choose an html file.'
  print '> '
  file_name = gets.chomp
end
temp_arr = file_name.split('/')


if temp_arr.length > 1
  file_path = file_name.strip
else
  file_path = File.join(APP_ROOT, file_name)
end

unless File.exists?(file_path)
      puts 'This file does not exist. Please provide a new path.'
      print '> '
      file_name = gets.chomp
end
puts file_path
file = FileReader.new(file_path)
file.to_tree







