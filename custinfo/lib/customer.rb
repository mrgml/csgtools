
require_relative 'model.rb'

class Customer
  
  def initialize(name)
    @model_list = []
    @name = name
    populate_models()
  end
  
  
  def to_s
    string_representation = "\nName: #{@name} \n"
    if (@model_list and @model_list.size() > 0)
      string_representation + "Models: \n" + @model_list.join("\n")
    end
  end
  
  # associate models with each customer
  private
  def populate_models
    model_dir = "#{$TRUNK}/#{@name}/models"
    Dir.foreach(model_dir) { |model_file|
      if (model_file.to_s.match('.*xml'))
        temp_model = Model.new("#{model_dir}/#{model_file}")
        # puts "temp_model is: #{temp_model}"
        # puts "@model_list.class is: #{@model_list.class}"
        if (temp_model)
          @model_list << temp_model
        end
      end
    }
  end
end