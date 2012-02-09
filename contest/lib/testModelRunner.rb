

def testModelRunner(script_location, changed_file)

  # Configure the resources
  modelTest42 = "#{$WORKSPACE}/touchpoint_4_2_br/bin/testModel.sh"
  modelTest45 = "#{$WORKSPACE}/touchpoint_4_5_br/bin/testModel.sh"
  modelTest51 = "#{$WORKSPACE}/touchpoint_5_1_br/bin/testModel.sh"
  modelTest52 = "#{$WORKSPACE}/touchpoint_5_2_br/bin/testModel.sh"
  touchpoint51home = "#{$WORKSPACE}/touchpoint_5_1_br"
  touchpoint52home = "#{$WORKSPACE}/touchpoint_5_2_br"
  touchpoint_home = nil
  # TODO: move these env's to a properties file, NB update the getting started file when this is done
  envJava15 = "~/.bash_java15"
  envJava16 = "~/.bash_java16"
  envJava = envJava16
  
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
  
  puts "Testing with: #{modelTest.strip}"

	return system("source #{envJava}; cd #{touchpoint_home} ; #{modelTest.strip} #{script_location.strip}/#{changed_file.strip}")
  
  
end








