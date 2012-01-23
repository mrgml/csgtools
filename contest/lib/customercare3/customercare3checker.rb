#!/usr/bin/env /usr/bin/ruby


def testCCv3(script_location, changed_file)
  puts "script_location is : #{script_location}"
  puts "changed_file is: #{changed_file}"
  customer = changed_file.split("/")[0]  # will give customer name ( string to first "/" )
  
  printf "Testing CQM vs. Models..."
  
  # find the models 
  model_list = []
  Dir.foreach("#{customer}/models") { |filename|    
    if (filename.to_s.match('.*xml')) 
      model_list << filename.to_s
    end
  }
  
  # puts "model_list is: #{model_list.join(",")}"
  
  # get the service names from the models
  available_services = []
  model_list.each { |model| 
    doc = Nokogiri::XML( File.open( "#{script_location.strip}/#{customer}/models/#{model}" ) )
    service_name_set = doc.xpath("/probe/computed-counters/computed-service/@name")
    service_name_set.each { |name| 
      available_services << name.to_s
    }
    
  }
  
  # puts "available_services is: #{available_services.join(',')}"
  
    
    
  # we have the available services, now check what customer care is only using what's available
  customercare_file = File.open( changed_file ) # changed file is customer care
  doc = Nokogiri::XML( customercare_file )
  
  
  expressionArray = doc.xpath("/customer-care/imei-tac-mapping/imei-counter/@name");
  # imei_counter_name looks like this: General3G.IMEITAC
  expressionArray.each { |imei_counter_name|
    if !( available_services.include?( imei_counter_name.to_s.split('.')[0] ) )
      # if the available services does not include everything we're using, fail the test
      return false
    end
  }
  
  return true
end
  
def load_properties(properties_filename)
  properties = {}
  File.open(properties_filename, 'r') do |properties_file|
    properties_file.read.each_line do |line|
      line.strip!
      if (line[0] != ?# and line[0] != ?=)
        i = line.index('=')
        if (i)
          properties[line[0..i - 1].strip] = line[i + 1..-1].strip
#        else
#          properties[line] = ''
        end
      end
    end      
  end
  properties
end  
  