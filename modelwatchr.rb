#!/usr/bin/env /usr/bin/ruby

require 'libxml'

def test(script_location, changed_file)

  if changed_file.match('model').nil?
    return  
  end

	# Configure the resources
	modelTest45 = "/Users/garylyons/Documents/workspace/touchpoint_4_5_br/bin/testModel.sh"
	modelTest51 = "/Users/garylyons/Documents/workspace/touchpoint_5_1_br/bin/testModel.sh"
	touchpoint51home = "/Users/garylyons/Documents/workspace/touchpoint_5_1_br"
	pass_image = "/Users/garylyons/rails_projects/contest/pass.png"
	fail_image = "/Users/garylyons/rails_projects/contest/fail.png"
	envJava15 = "/Users/garylyons/.bash_profile"
	envJava16 = "/Users/garylyons/.bash_java16"
	envJava = envJava15
	
	puts script_location
	puts changed_file
	
	parser = LibXML::XML::Parser.file(changed_file)
	xmlDoc = parser.parse
	modelVersion =  xmlDoc.find('/probe/header/@version').first.to_s  # this gives the contents of the version attribute
	puts modelVersion
  
  modelTest = modelTest45
  
  if modelVersion.match('5\.1')
    modelTest = modelTest51
    envJava = envJava16
  else nil
  end

	# Select and run the appropriate test/s;  stripping because system is giving me "/n"
	if changed_file.match('models')
		test = "testModel.sh"
		status = system("source #{envJava}; cd #{touchpoint51home} ; #{modelTest.strip} #{script_location.strip}/#{changed_file.strip}")
	else
	  puts.nil
	end
	
	# Now growl the result
	application_name = "Continyous"
	if status
		image = pass_image
		result = "#{changed_file.split("/").last} has just passed #{test}"
	else
		image = fail_image
		result = "#{changed_file.split("/").last} has just failed #{test}"
	end
	# puts "'/usr/local/bin/growlnotify -n \"#{application_name}\" --image \"#{image}\" -m \"#{result}\" '"
	# puts `which growlnotify`
	`/usr/local/bin/growlnotify -n \"#{application_name}\" --image \"#{image}\" -m \"#{result}\"`
end
		
watch( '.*\.xml' )  { |md| test(`pwd`,md[0]) } 
