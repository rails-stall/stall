module Stall
  # The DSL allows for declaring instance-level configuration params
  # with defaults in a single line
  #
  module ConfigDSL
    def param(name, default = nil)
      attr_writer name

      instance_variable_name = :"@#{ name }"

      define_method(name) do
        instance_variable_get(instance_variable_name) ||
          instance_variable_set(instance_variable_name, default)
      end
    end
  end

  class Config
    extend Stall::ConfigDSL

    # Default VAT rate
    param :vat_rate, BigDecimal.new('20.0')

    # Default prices precision for rounding
    param :prices_precision, 2

    # Engine's ApplicationController parent
    param :application_controller_ancestor, '::ApplicationController'
  end
end
