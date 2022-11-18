APP_ROOT = File.expand_path(File.dirname(__FILE__))




require_relative 'my_classes/tree'
require_relative 'my_classes/file_reader'
require_relative 'my_classes/tree_to_html'
include TreeToHtml


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
root_node = file.to_tree

puts 'What do you want to call the new file?'
print '> '
output_name = gets.chomp

until output_name.include?('.html')
  puts 'Please end the file name with .html'
  print '> '
  output_name = gets.chomp
end

if File.exists?(File.join(APP_ROOT, output_name))
  puts 'This file already exists. Please choose a new name.'
  print '> '
  output_name = gets.chomp
end



reformat_html(root_node, output_name)







