module TreeToHtml

  def reformat_html(root_node, output_name)
    

    #creates an output path variable
    outputpath = File.join(APP_ROOT, output_name)

    
    #creates the new file and adds the tag for the parent element
    File.open(outputpath, 'a') do |file|
      file << "<#{root_node.name} data-type=\"#{root_node.data_type}\">"
      file << "\n"
    end

    #temporary holder for the section element
    section_holder = []

    
    #interates over the children of the root node
    root_node.children.each_with_index do |child, i|

      #checks if it is the section element
      if child.name == 'section'
        
        
        child.text.each_with_index do |line, i|
          #removes whitespace to maintain formatting
          if line.gsub(/\s+/, "").length > 0 
              if line.include? '\n'
                line['\n'] = ''
              end
              if line == ' ' || line == ''
                next
              end
              section_holder.push(line)
            end
          end
          
          
       
      #checks if it is the chapter review so it can place the section element inside it 
      elsif child.class == 'chapter-review' 
        File.open(outputpath, 'a') do |file|
          file << "  <#{child.name} class=\"#{child.class}\">"
          file << "\n"
          section_holder.each_with_index do |line, i|
           
            if line.gsub(/\s+/, "").length > 0 
              line.gsub("\n", '')
              file << "  #{line}"
              
            end
            
          end
          file << "  </#{child.name}>"
          file << "\n"
        end
      else
        #this covers the exercises and paragraph elements

        #checks if it is a one line or multi-line element
        if child.text.is_a? String
        
          File.open(outputpath, 'a') do |file|
            file << child.text                      
          end
          
        else
        #this covers multi-line elements          
          File.open(outputpath, 'a') do |file|
           #iterates over text array  
            child.text.each_with_index do |line, i|
              #makes sure to not put any empty lines
              if line.gsub(/\s+/, "").length > 0 
                  file << line 
              end              
            end
          end
        end
      end
    end
    #closes out the file
    File.open(outputpath, 'a') do |file|
      file << "</#{root_node.name}>"
    end

    puts "Your new HTML file was saved at #{outputpath}"
  end
end