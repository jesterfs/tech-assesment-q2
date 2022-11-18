class FileReader

  require_relative 'tree'
  require_relative 'tree_to_html'
  include TreeToHtml
  
  
  attr_accessor :file

  @@valid_sections = ['<div', '<section', '<p', '<h1', '<h2', '<h3']

  
  def initialize(filepath) 
      @filepath = filepath
  end

 

  def to_tree
    #reads all lines of the file into an array
      lines = File.readlines(@filepath)
    #collects data from the first line, which will be the parent node
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
    
      #creates the parent node
      root_node = TreeNode.new(first_name, first_data, first_text,   first_id, first_class)

    # When collecting_text is true, the tool will treat the following lines as one child
    collecting_text = false
    #Variables used in text collection
    text_holder = []
    current_section = nil
    current_data = nil
    current_id = nil
    current_class = nil
    #counter used for adding the excercise number divs
    exercise_number = 0

      #interates over the lines
      lines.each_with_index do |line, i|
        #skips the first line, which has already been created as a code
        if i == 0 
          next
        end
        
        #collects text for multi-line elements
        if collecting_text
          #stops collecting if the element ends on the current line
          if line.include?("</#{current_section}>")
            if line.include? "\n"
              line.gsub("\n", "")
            end
            text_holder.push(line)
            #creates child node with the complete text as an array of lines
            root_node.children << TreeNode.new(current_section, current_data, text_holder, current_id, current_class)
            #resets the text collection variables
            collecting_text = false
            text_holder = []
            current_section = nil
            current_data = nil
            current_id = nil
            current_class = nil
            next
          else
            #collects multi-line texts
            if line.include? "\n"
              line.gsub("\n", "")
            end
            text_holder.push(line)
            next
          end

        end

        
        #empty variables for populating the child node values
        name = nil
        data_type = nil
        text = nil
        id = nil
        sec_class = nil
        
        #splits line to collect name, data type, id, class, etc
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

        #if the line includes a closing tag, it will collect the whole line as the text
        #and move on.
        if line.include?("</#{name}>")
          text = line
          if text.include? "\n"
              line.gsub("\n", "")
          end
          
          #creates a new chile node
          root_node.children << TreeNode.new(name, data_type, text, id, sec_class)
        else

          #if the line does not include a closing tag, the tool enters text collection mode
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

    #returns the root node, which will be passed onto the next step on main
     return root_node
    end
end