#!/usr/bin/env ruby

# Have to find and set the location of the testing scripts
# It's either this way or hack a route through watchr
# Using a global variable so it can be accessed in the class too
$CONTEST_LOCATION = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH << $CONTEST_LOCATION

require 'nokogiri'  # for XML parsing

require "#{$CONTEST_LOCATION}/lib/customercare3checker.rb"
require "#{$CONTEST_LOCATION}/lib/testModelRunner.rb"
require "#{$CONTEST_LOCATION}/lib/ModelDeploymentTester.rb"
require "#{$CONTEST_LOCATION}/lib/ChartExportLogoTester.rb"
require "#{$CONTEST_LOCATION}/lib/start_format_check.rb"
require "#{$CONTEST_LOCATION}/lib/event_persistence_check.rb"

class ModelWatchr 
  def self.test(script_location, changed_file)
    customer = changed_file.split("/")[0]  # will give customer name ( string to first "/" )
    pass_image = "#{$CONTEST_LOCATION}/pass.png"
    fail_image = "#{$CONTEST_LOCATION}/fail.png"
    test = ""

  #  puts changed_file

    if changed_file.match('customercare3.xml')
      # it's a customercare v3 file, pass to ccv3 test
      status = testCCv3(script_location, changed_file)
      test = "No test at all."
    end
  
    if changed_file.match('features.ext.properties')  # NB this is a regex match
      begin
        my_tester = ExportLogoTest.new
        status = my_tester.checkExportLogo(script_location, changed_file)
        test = "Exported Reports Logo"
      rescue Exception
        STDERR.puts "Exported Reports Logo"
      end

      if status then
        begin
          status = event_persistence_check(script_location, changed_file)
          if status
            test += "\nevent-persistence-property"
          else
            test = "\nevent-persistence-property"
          end
        rescue Exception => whatever_exception
         STDERR.puts "Got exception running event-persistence-property"
         STDERR.puts whatever_exception
        end
      end
    
    end
  
  
  	# Select and run the appropriate test/s;  stripping because system is giving me "/n"
    if changed_file.match('models')
      begin
        status = testModelRunner(script_location, changed_file)
        test = "\ntestModel.sh"
      rescue Exception => test_model_exception
        STDERR.puts "Got exception running testModel.sh"
        STDERR.puts test_model_exception
      end
      if status then
        begin
          status = start_format_check(script_location, changed_file)
          if status
            test += "\nstart-format"
          else
            test = "\nstart-format"
          end
        rescue Exception => exception
          STDERR.puts "Got exception running start-format"
          STDERR.puts "Exception info: \n #{exception} \n #{exception.backtrace.join("\n")}"
          STDERR.puts "The exception model is: #{changed_file}"
        end
      end
    
    else
    end
	
	
  	# if it passes testModel.sh call a script to test that the model deploys/upgrades.
    if status
    	if isDeployValid(script_location, changed_file)
    	  # call capistrano to deploy it (somehow)
    	  # get the remote status
      end
    end
	
  	# Now growl the result
  	application_name = "Contest"
  	@sticky = ""
  	if status
  		image = pass_image
  		result = "#{customer}: \n #{changed_file.split("/").last} has just passed: #{test}"
  	elsif status == false
  		image = fail_image
  		result = "#{customer}: \n #{changed_file.split("/").last} has just failed: #{test}"
  		@sticky = "-s"
  	else
  	  return
  	end
  	# puts "'/usr/local/bin/growlnotify -n \"#{application_name}\" --image \"#{image}\" -m \"#{result}\" '"
  	# puts `which growlnotify`
  	`/usr/local/bin/growlnotify #{@sticky} -n \"#{application_name}\" --image \"#{image}\" -m \"#{result}\"`
  end
end
		
watch( '.*\.(xml|properties)' )  { |md| ModelWatchr.test(`pwd`,md[0]) } 
