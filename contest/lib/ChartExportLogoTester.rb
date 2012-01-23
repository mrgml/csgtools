

class ExportLogoTest

  # This test checks for the export logo referenced in the features-ext.properties file
  # it checks for 1: presence, 2: validity of format and 3: presence of referenced file

  def checkExportLogo(script_location, changed_file)
    
    puts "Testing chart_export_logo property..."
    
    exportLogoProperty = "chart_logo_export"
  
    customer = changed_file.split("/")[0]  # will give customer name ( string to first "/" )
    
    puts "customer is: #{customer}"
  
    requiredPropertyStart = "reports.images."
  
    # First, find the property string
    props = load_properties("#{script_location.strip}/#{changed_file.strip}")
    chartProp = props[exportLogoProperty]
  
    # Second, check the validity of the property string, should start with reports.images.
    if !chartProp.nil? and chartProp.index(requiredPropertyStart) == 0
      # Third, check the image file referenced actually exists
      if File.exist?("#{script_location.strip}/#{customer}/reports/images/#{chartProp.sub(requiredPropertyStart,"")}")
        puts "Passed."
        return true
      else
        return false
      end
    else
      puts "This features_ext.properties should contain the chart_logo_export property:   #{script_location.strip}/#{changed_file.strip}.  
The required format is: #{exportLogoProperty}=#{requiredPropertyStart}logo.file"
      return false
    end
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
          else
            properties[line] = ''
          end
        end
      end      
    end
    properties
  end

end


# main method for CLI

if __FILE__ == $0
  x = ExportLogoTest.new()
  x.checkExportLogo(ARGV[0],ARGV[1])
end


