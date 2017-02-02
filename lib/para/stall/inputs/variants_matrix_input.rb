module Para
  module Stall
    module Inputs
      class VariantsMatrixInput < SimpleForm::Inputs::Base
        include VariantInputHelper

        def input(wrapper_options = nil)
          ensure_target_relation_present!

          template.render partial: 'para/stall/inputs/variants_matrix', locals: {
            form: @builder,
            model: model,
            attribute_name: attribute_name,
            properties: properties,
            variants: variants,
            require_all_properties: require_all_properties,
            dom_identifier: dom_identifier,
            variant_row_locals: variant_row_locals
          }
        end

        private

        def properties
          @properties ||= options[:properties].map do |property_name, model_name|
            VariantsPropertyConfig.new(
              resource,
              property_name,
              relation: attribute_name,
              model_name: model_name
            )
          end
        end

        def variants
          @variants ||= resource.send(attribute_name).sort_by(&method(:variant_sort_method))
        end

        def require_all_properties
          options[:require_all_properties] || false
        end

        def dom_identifier
          @dom_identifier ||= [
            model.model_name.element,
            resource.id || resource.object_id,
            attribute_name
          ].join('-')
        end

        def variant_row_locals
          {
            model: model,
            attribute_name: attribute_name,
            properties: properties,
            dom_identifier: dom_identifier
          }
        end
      end
    end
  end
end
