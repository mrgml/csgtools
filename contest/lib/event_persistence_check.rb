require 'nokogiri'

def event_persistence_check(script_location, changed_file)
  printf "Testing event persistence flag..."
  properties_file_name = "features-ext.properties"
  event_persistence_prop = "collection.event.persistence"
  enabled_values = ["on", "true", "yes", "enabled", "yep"]
  result = false
  
  customer = changed_file.split("/")[0]
  # puts "customer is : #{customer}"
  
  props = load_properties("#{script_location.strip}/#{changed_file.strip}")
  event_persistence_prop_value = props[event_persistence_prop]
  # puts "event_persistence_prop_value is :#{event_persistence_prop_value}."

  if !event_persistence_prop_value
    result = true
  end
  
  if result
    puts "Passed."
  else
    puts "Failed."
  end
  puts "result is: #{result}"
  
  return result
  
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









