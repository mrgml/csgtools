#!/usr/bin/env /usr/bin/ruby


def testCCv3(script_location, changed_file)
  puts changed_file
  printf "Testing CQM vs. Models..."
  customercare_file = File.open( changed_file )
  doc = Nokogiri::XML( customercare_file )
  
  expressionArray = doc.xpath("/customer-care/service-groups/service-group/service//expression");
  
  
  
  return true
end
  
  