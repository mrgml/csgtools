require 'libxml'

class FieldIDlister
  
  # parse results file
  def load_results(results_filename = "result.xml")
    # set up arrays to hold results from schematron output
    result_XPaths = []
    result_newValues = []
    
    # unfortunately I don't know enough not to hack the path to prepend to the file
    path_to_here = "/Users/garylyons/Documents/workspace/csg/customers/trunk/vodacom_sa/models/"
    results_filename =  path_to_here + results_filename
    
    # store locations and new values
    parser = LibXML::XML::Parser.file(results_filename)
    xmlDoc = parser.parse
    resultFileNameSpace = 'svrl:http://purl.oclc.org/dsdl/svrl'
    
    # create the absolute path to the model file
    model_file = path_to_here + xmlDoc.find('/fileset/file/@name',resultFileNameSpace).first.to_s.split(' ')[2]

    xmlDoc.find('/fileset/file/svrl:schematron-output/svrl:failed-assert/@location',resultFileNameSpace).each do | location |
      result_XPaths << location.first.to_s.split(' ')[2]
    end

    xmlDoc.find('/fileset/file/svrl:schematron-output/svrl:failed-assert/@test',resultFileNameSpace).each do | newValue |
      result_newValues << newValue.first.to_s 
    end
    
    for i in 0..(result_XPaths.length-1)
      xpath = result_XPaths[i]
      # sample location from input file: 
      # /probe[1]/computed-counters[1]/computed-service[1]/index[1]/common[1]/computed-distribution[1]
      model_parser = LibXML::XML::Parser.file(model_file)
      model_doc = model_parser.parse
      
      # Get the service name from the model
      xpath_to_service = "/" + xpath.split('/')[1] + "/" + xpath.split('/')[2] + "/" + xpath.split('/')[3]
      servicename_xpath =  xpath_to_service + "/@name"
      service =  model_doc.find(servicename_xpath).first.to_s.split(' ')[2]
      
      # Now the index name
      xpath_to_index = xpath_to_service + "/" + xpath.split('/')[4]
      indexname_xpath = xpath_to_index + "/@type"
      index = model_doc.find(indexname_xpath).first.to_s.split(' ')[2]
      
      # Finally the distribution name
      xpath_to_dist = xpath_to_index + "/" + xpath.split('/')[5] + "/" + xpath.split('/')[6]
      distname_xpath = xpath_to_dist + "/@name"
      dist = model_doc.find(distname_xpath).first.to_s.split(' ')[2] 
      
      field_id_xpath = xpath_to_dist + "/@field-id"
      field_id = model_doc.find(field_id_xpath).first.to_s.split(' ')[2] 
      
      # Tie it all together
      puts "The old field_id for #{dist} on the #{service} service, #{index} index was: #{field_id}, the new one is #{result_newValues[i].split('\'')[1]}."

    end
  end 
end
  
  
# main method for CLI

if __FILE__ == $0
  x = FieldIDlister.new()
  x.load_results(ARGV[0])
end
