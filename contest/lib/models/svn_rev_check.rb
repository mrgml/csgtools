

def svn_rev_check(script_location, changed_file)
  printf "Testing svn_rev_check..."
      
  # get the version from the model
  model_file = File.open( changed_file )
  doc = Nokogiri::XML( model_file )
  version = doc.xpath("/probe/header/@version").to_s
  puts "version is: #{version}"
  
  # check for generated model
  is_src_revision_set = /src/.match(version)
  is_ref_revision_set = /ref/.match(version)
  if (!is_src_revision_set && !is_ref_revision_set) then 
    run_test = true 
  else
    puts "Passed (not required in generated models)."
    return true
  end
  
  svn_propget_output = `svn propget svn:keywords #{changed_file}`
  
  pattern = /Rev/
  match_result = pattern.match(svn_propget_output)
  matched_segment = ""
  if match_result
    puts "match_result[0] is: #{match_result[0]}"
    matched_segment = match_result[0]
  end
  
  if ( matched_segment.length > 0 and run_test ) then 
    result = true 
  else 
    result = false 
  end
  
  if result == true
    puts "Passed."
  else
    puts "Failed."
    result = false
  end
  
  return result
  
end










