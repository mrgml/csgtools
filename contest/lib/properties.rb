

def Properties
  @proplist # store the properties in here like this:  filename.property.name  ; where filename omits extension
  def get(requested_property)
    
  end
  
  # TODO: create set method

private
  def load_properties(properties_filename)
    # TODO store the files these properties came from and poll them for updates
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