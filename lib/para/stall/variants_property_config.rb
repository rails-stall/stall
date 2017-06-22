module Para
  module Stall
    class VariantsPropertyConfig
      attr_reader :resource, :property, :variants

      def initialize(resource, property, variants)
        @resource = resource
        @property = property
        @variants = variants
      end

      def options
        property.property_values.map do |property_value|
          [
            property_value.value,
            property_value.id,
            selected: property_value_used?(property_value),
            data: { name: property_value.value }
          ]
        end
      end

      def active?
        variants.any? do |variant|
          variant.variant_property_values.any? do |variant_property_value|
            variant_property_value.property_value.try(:property) == property
          end
        end
      end

      def current_value
        @current_value ||= property.property_values.find do |property_value|
          property_value_used?(property_value)
        end
      end

      def one_available_value?
        available_options.length == 1
      end

      def available_options
        @available_options ||= available_property_values.map do |property_value|
          [property_value.value, property_value.id]
        end
      end

      def available_property_values
        @available_property_values ||= property.property_values.each_with_object([]) do |property_value, ary|
          if property_value_used?(property_value)
            ary << property_value
          end
        end
      end

      def property_value_for(variant)
        variant_property_value_for(variant).try(:property_value)
      end

      def variant_property_value_for(variant)
        variant_property_value = variant.variant_property_values.find do |variant_property_value|
          variant_property_value.property_value.try(:property) == property
        end
      end

      def variant_property_value_or_build_for(variant)
        variant_property_value_for(variant) || variant.variant_property_values.build
      end

      private

      def variant_model
        @variant_model ||= resource.class.reflect_on_association(relation).klass
      end

      def reflection
        @reflection ||= variant_model.reflect_on_association(property.name)
      end

      def property_value_used?(property_value)
        variants.any? do |variant|
          variant.variant_property_values.any? do |variant_property_value|
            variant_property_value.property_value == property_value
          end
        end
      end
    end
  end
end
