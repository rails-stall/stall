module Para
  module Stall
    module Inputs
      module VariantInputHelper
        private

        def resource
          @resource ||= @builder.object
        end

        def model
          @model ||= resource.class
        end

        def variant_sort_method(variant)
          properties.map do |property_config|
            if (variant_value = property_config.variant_property_value_for(variant))
              variant_value.property_value.position
            end
          end.join(':')
        end

        # Raises a comprehensive error for easy wrong form attribute catching
        #
        def ensure_target_relation_present!
          unless model.reflect_on_association(attribute_name)
            raise NoMethodError,
              "Relation ##{ attribute_name } does not exist for model #{ model.name }."
          end
        end
      end
    end
  end
end
