

def testModelRunner(script_location, changed_file)

  # Configure the resources
  modelTest42 = "/Users/garylyons/Documents/workspace/touchpoint_4_2_br/bin/testModel.sh"
  modelTest45 = "/Users/garylyons/Documents/workspace/touchpoint_4_5_br/bin/testModel.sh"
  modelTest51 = "/Users/garylyons/Documents/workspace/touchpoint_5_1_br/bin/testModel.sh"
  modelTest52 = "/Users/garylyons/Documents/workspace/touchpoint_5_2_br/bin/testModel.sh"
  touchpoint51home = "/Users/garylyons/Documents/workspace/touchpoint_5_1_br"
  touchpoint52home = "/Users/garylyons/Documents/workspace/touchpoint_5_2_br"
  touchpoint_home = nil
  envJava15 = "/Users/garylyons/.bash_profile"
  envJava16 = "/Users/garylyons/.bash_java16"
  envJava = envJava15
  
  puts script_location
  puts changed_file 
  
  model_file = File.open( changed_file )
  xml_doc = Nokogiri::XML( model_file )
  modelVersion = xml_doc.xpath("/probe/header/@version").to_s

  modelTest = modelTest42

  if modelVersion.match('5\.1')
    touchpoint_home = touchpoint51home
    modelTest = modelTest51
    envJava = envJava16
  elsif modelVersion.match('5\.2')
    touchpoint_home = touchpoint52home    
    modelTest = modelTest52
    envJava = envJava16
  elsif modelVersion.match('4\.5')
    modelTest = modelTest45
  else
    return "File untestable."
  end
  

	return system("source #{envJava}; cd #{touchpoint_home} ; #{modelTest.strip} #{script_location.strip}/#{changed_file.strip}")
  
  
end








