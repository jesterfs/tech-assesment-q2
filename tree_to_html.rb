module TreeToHtml

  def reformat_html(root_node)
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

    
    outputpath = File.join(APP_ROOT, output_name)

    

    File.open(outputpath, 'a') do |file|
      file << "<#{root_node.name} data-type=\"#{root_node.data_type}\">"
      file << "\n"
    end

    
    section_holder = []

    exercise_number = 0

    root_node.children.each_with_index do |child, i|
      if child.name == 'section'
        #section_holder.push("  <#{child.name}>")
        
        child.text.each_with_index do |line, i|
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
          
          
        #section_holder.push"  </#{child.name}>"
        
      elsif child.class == 'chapter-review' 
        File.open(outputpath, 'a') do |file|
          file << "  <#{child.name} class=\"#{child.class}\">"
          file << "\n"
          #file << "    <section>"
          #file << "\n"
          section_holder.each_with_index do |line, i|
           
            if line.gsub(/\s+/, "").length > 0 
              line.gsub("\n", '')
              file << "  #{line}"
              
            end
            
          end
          #file << "    </section>"
          #file << "\n"
          file << "  </#{child.name}>"
          file << "\n"
        end
      else
        if child.text.is_a? String
          open_tag = "  <#{child.name} data_type=#{child.data_type} id=#{child.id} class=#{child.class}>#{child.text}</#{child.name}>"

          
          if !child.data_type
            open_tag['data_type=""'] = ''
          end

          if !child.id
            open_tag[' id='] = ''
          end

          if !child.class
            open_tag['class='] = ''
          end

          File.open(outputpath, 'a') do |file|
            file << child.text
            #file << "\n"
            
          
          end
          
        else
          open_tag = "  <#{child.name} data_type=#{child.data_type} id=#{child.id} class=#{child.class}>"
          

          
          if !child.data_type
            open_tag['data_type='] = ''
          end

          if !child.id
            open_tag[' id='] = ''
          end

         if !child.class
            open_tag['class='] = ''
          end
          File.open(outputpath, 'a') do |file|
           #file << open_tag
            #unless child.name == 'p'
             #file << "\n"
            #end

            #if child.data_type == 'exercise'
             # exercise_number += 1
              #file << "    <div class='os-number'>#{exercise_number}</div>"
             # file << "\n"
            #end
  
            child.text.each_with_index do |line, i|
              if line.gsub(/\s+/, "").length > 0 
                  file << line
                
              end
              
              
            end
  
            #file << "  </#{child.name}>"
            #file << "\n"
          end
        end
      end
    end
    File.open(outputpath, 'a') do |file|
      file << "</div>"
    end
  end

end