APP_ROOT = File.expand_path(File.dirname(__FILE__))

require_relative "../my_classes/file_reader"
require_relative '../my_classes/tree_to_html'
include TreeToHtml
require "test/unit"
 
class TestFileReader < Test::Unit::TestCase
  file_path = File.join(APP_ROOT, 'test_output.html')
  #test_file = File.new(file_path, 'r')
  #test_output = File.readlines(file_path)
 
  def test_file_reader
    test = FileReader.new('tests/test_input.html').to_tree
    #compare = FileReader.new('test_output.html').to_tree
    assert_equal('div', test.name  )
    assert_equal(1, test.children.length  )
    assert_equal('p', test.children[0].name  )  
    assert_equal("    <p id=\"123\">Water consists of the elements hydrogen and oxygen combined in a 2 to 1 ratio.</p>\n", test.children[0].text  ) 
  end

  def test_tree_to_html
    root_node = FileReader.new('tests/test_input.html').to_tree
    output_path = File.join(APP_ROOT, 'test_out.html')
    reformat_html(root_node, 'test_out.html')
    assert_equal(true, File.exists?(output_path)  )
    lines = File.readlines(output_path)
    assert_equal("<div data-type=\"note\">\n", lines[0]  )
    assert_equal("    <p id=\"123\">Water consists of the elements hydrogen and oxygen combined in a 2 to 1 ratio.</p>\n", lines[1]  )
    assert_equal("</div>", lines[2]  )


    File.delete(output_path)
  end
 
end