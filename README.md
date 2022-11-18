# HTML to Tree to Reformatted HTML

## Tech Assessment for OpenStax

## By Stewart Jester

This Ruby CLI tool takes in an HTML file, converts it to a data tree, and outputs
and HTML file with specific transformations. While it is currently set up to meet
the specific demands of a specific request, the specified transformations can be
changed in my_classes/tree_to_html.rb .

If you upload an HTML file that does not meet any of the conditions in said file,
it will still be converted to a data tree, but the outputted file will be identical
to the inputted.

## How to use the tool

After downloading the files, navigate into the tech-assessment-q2 folder in your
command line.
execute 'ruby main.rb'

You will then be asked to provide the path to your input file. The input file it
was built for is in this folder, so you can simply type 'input.html'. However, with
a complete path, you can also use an external file.

You will then be asked to name your new file, which will then appear in the main folder of this application.
