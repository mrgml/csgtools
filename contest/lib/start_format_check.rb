

def start_format_check(script_location, changed_file)
  printf "Testing start-format..."
  date_format_strings = {
    "yyyy" => "2011",
    "yy" => "11",
    "MM" => "05",
    "dd" => "12",
    "HH" => "15",
    "mm" => "42",
    "ss" => "23"
  }
  
  model_file = File.open( changed_file )
  doc = Nokogiri::XML( model_file )
  
  filename_regex_node = doc.xpath("/probe/file-description/@filename-regex")
  start_format_node = doc.xpath("/probe/file-description/@start-format")
  
  filename_regex = filename_regex_node.to_s
  start_format = start_format_node.to_s
  regex_pattern = /\((.*)\)/
  
  # puts "filename_regex is: #{regex_pattern}"
  # puts "filename_regex is: #{filename_regex}"
  # puts "start_format is #{start_format}"
  
  my_matchdata = regex_pattern.match(filename_regex)
  if !my_matchdata
    return nil
  end
  # puts "my_matchdata is: #{my_matchdata}"
  start_format_pattern = Regexp.new($1)  # $1 is the first group in the regex
  
  date_format_strings.each_pair do |key, value|
    start_format.gsub!(key, value)
  end
  start_sample = start_format
  # puts "start_sample is #{start_sample}"
  # puts "start_format_pattern is: " + start_format_pattern.to_s
  
  result = start_format_pattern.match(start_sample)

  
  if result.to_s == start_sample
    puts "Passed."
  else
    puts "Failed."
    result = false
  end
  
  return result
  
  
end










