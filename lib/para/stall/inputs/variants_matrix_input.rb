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

          ensure_empty_variant_if_needed

          template.render partial: 'para/stall/inputs/variants_matrix', locals: {
            form: @builder,
            model: model,
            attribute_name: attribute_name,
            all_properties: all_properties,
            properties: properties,
            variants: variants,
            dom_identifier: dom_identifier,
            variant_row_locals: variant_row_locals,
            allow_empty_variant: allow_empty_variant
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

        def allow_empty_variant
          @allow_empty_variant ||= options.fetch(:allow_empty_variant, true)
        end

        def ensure_empty_variant_if_needed
          object.variants.build if object.variants.empty? && allow_empty_variant
        end
      end
    end
  end
end
