#!/usr/bin/env ruby

require_relative 'lib/customer'

$WORKSPACE = ENV['workspace']
$TRUNK = "#{$WORKSPACE}/csg/customers/trunk"

class CustomerInfo
  puts "The workspace is set to: #{$WORKSPACE}"
  puts "The csg trunk dir is set to: #{$TRUNK}"
  @@customer_list = []

  
  # iterate through the customers
  # iterate through models to retrieve type and vendor
  # output list of: Type, Vendor, filename
  # enhancement: create grid listing services, indexes and CEI's
  
  def initialize() 
    Dir.foreach("#{$TRUNK}") { |potential_customer_directory|    
      if (File.exist?("#{$TRUNK}/#{potential_customer_directory}/features/features-ext.properties")) 
        @@customer_list << Customer.new(potential_customer_directory)
      end
    }  

  end
  
  def print_customer_list()
    if (@@customer_list.size() > 0)
      puts "list of customers is now: " 
      @@customer_list.each { |customer| puts customer.to_s }
    end
  end
  
end

# main method for CLI

if __FILE__ == $0
  x = CustomerInfo.new()
  x.print_customer_list()
  # x.parse(ARGV[0])
end



