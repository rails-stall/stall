module Para
  module Stall
    module Inputs
      class VariantsMatrixInput < SimpleForm::Inputs::Base
        include VariantInputHelper

        def initialize(*)
          super
          options[:label] = false
        end

        def input(wrapper_options = nil)
          ensure_target_relation_present!

          template.render partial: 'para/stall/inputs/variants_matrix', locals: {
            form: @builder,
            model: model,
            attribute_name: attribute_name,
            all_properties: all_properties,
            properties: properties,
            variants: variants,
            require_all_properties: require_all_properties,
            dom_identifier: dom_identifier,
            variant_row_locals: variant_row_locals
          }
        end

        private

        def all_properties
          @all_properties ||= Property.includes(:property_values).all.map do |property|
            VariantsPropertyConfig.new(resource, property, unsorted_variants)
          end
        end

        def properties
          @properties ||= all_properties.select(&:active?)
        end

        def unsorted_variants
          @unsorted_variants ||= resource.send(attribute_name)
        end

        def variants
          @variants ||= unsorted_variants.sort_by(&method(:variant_sort_method))
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
            all_properties: all_properties,
            properties: properties,
            dom_identifier: dom_identifier
          }
        end
      end
    end
  end
end
