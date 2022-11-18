class FileReader

  require_relative 'tree'
  require_relative 'tree_to_html'
  include TreeToHtml
  
  # require 'sanitize'
  attr_accessor :file

  @@valid_sections = ['<div', '<section', '<p', '<h1', '<h2', '<h3']

  
  def initialize(filepath) 
      @filepath = filepath
  end

 

  def to_tree
      lines = File.readlines(@filepath)
      first = lines[0]
      first['<'] = ''
      first['>'] = ''
      first_arr = first.split(' ')
      first_name = nil
      first_data = nil
      first_text = nil
      first_id = nil
      first_class = nil

      first_arr.each_with_index do |item, i|
        if i == 0
          first_name = item
        elsif item.include?('data-type')
          substr = item
          substr['data-type="'] =''
          substr['"'] =''
          first_data = substr
        end
      end
    
      root_node = TreeNode.new(first_name, first_data, first_text,   first_id, first_class)

    text_holder = []
    exercise_number = 0
    collecting_text = false
    current_section = nil
    current_data = nil
    current_id = nil
    current_class = nil

      lines.each_with_index do |line, i|
        if i == 0 
          next
        end
        
        if collecting_text
          if line.include?("</#{current_section}>")
            
            #line["</#{current_section}>"] =''
            if line.include? "\n"
              line.gsub("\n", "")
            end
            text_holder.push(line)
            root_node.children << TreeNode.new(current_section, current_data, text_holder, current_id, current_class)
            collecting_text = false
            text_holder = []
            current_section = nil
            current_data = nil
            current_id = nil
            current_class = nil
            next
          else
            if line.include? "\n"
              line.gsub("\n", "")
            end
            text_holder.push(line)
            next
          end

        end

        

        name = nil
        data_type = nil
        text = nil
        id = nil
        sec_class = nil
        
        line_arr = line.split(' ')
        temp_name = line_arr[0]

        if temp_name.include?('>')
          temp_arr = temp_name.split('>')
          temp_name = temp_arr[0]
        end

        if @@valid_sections.include?(temp_name)
          name = temp_name
          name['<'] = ''
        end

        if line.include?('data-type')
          data_type_arr = line_arr[1].split('">')
          data_type = data_type_arr[0]
          data_type['data-type="'] = ''          
        end

        if line.include?(' id')          
          id_arr = line_arr[1].split('">')
          id = id_arr[0]
          id['id="'] = ''          
        end

        if line.include?(' class=')          
          class_arr = line_arr[1].split('">')
          sec_class = class_arr[0]
          sec_class['class="'] = '' 
        end

        if line.include?("</#{name}>")
          #hold_arr1 = line.split('>')
          #hold_arr2 = hold_arr1[1].split('<')
          #text = hold_arr2[0]
          text = line
          if text.include? "\n"
              line.gsub("\n", "")
          end
          
          root_node.children << TreeNode.new(name, data_type, text, id, sec_class)
        else

          
          current_section = name
          current_data = data_type
          current_id = id
          current_class = sec_class
          collecting_text = true
          text_holder.push(line)
          if data_type == 'exercise'
            exercise_number += 1
            text_holder.push("    <div class=\"os-number\">#{exercise_number}</div>\n")
          end
          next
        end  
      end
     reformat_html(root_node)
    end
end