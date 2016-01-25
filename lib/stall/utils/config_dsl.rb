module Stall
  module Utils
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
  end
end
