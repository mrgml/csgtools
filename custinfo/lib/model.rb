require 'nokogiri'

# This class represents a model
class Model

  
  def initialize(file)
    @file = file
    parse(@file)
    
    @type
    @vendor
    @services
    @indexes
  end
  
  def to_s
    @vendor + "," + @type + "," +  @file
  end

private
  # pull out the object variables from the model
  def parse(file)
    doc = Nokogiri::XML( File.open( file ) )
    @type = doc.xpath("/probe/header/@type").to_s
    @vendor = doc.xpath("/probe/header/@vendor").to_s
    @services = "<TODO>"
    @indexes = "<TODO>"
  end
  
end


