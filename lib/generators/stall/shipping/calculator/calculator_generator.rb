module Stall
  module Shipping
    class CalculatorGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)

      def copy_calculator_template
        template 'calculator.rb.erb', "lib/#{ file_path }.rb"
      end

      def register_calculator_in_initializer
        insert_into_file "config/initializers/stall.rb", after: "Stall.configure do |config|\n" do
          indent "config.shipping.register_calculator :#{ singular_name }, #{ class_name }\n"
        end
      end
    end
  end
end
