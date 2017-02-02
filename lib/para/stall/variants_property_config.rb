module Para
  module Stall
    class VariantsPropertyConfig
      attr_reader :resource, :property_name, :relation, :property_model

      def initialize(resource, property_name, options = {})
        @resource = resource
        @property_name = property_name
        @relation = options[:relation]
        @variants = options[:variants]

        @property_model = if (model_name = options[:model_name])
          model_name.constantize
        else
          reflection.klass
        end
      end

      def options
        property_model.all.map do |property|
          name = property_name_for(property)

          [
            name,
            property.id,
            selected: property_used?(property),
            data: { name: name }
          ]
        end
      end

      def available_options
        @available_options ||= variants_by_property.keys.map do |property|
          [property_name_for(property), property.id]
        end
      end

      def foreign_key
        @foreign_key ||= reflection.foreign_key
      end

      def property_name_for(property)
        return unless property

        Para.config.resource_name_methods.each do |method_name|
          if (name = property.try(:name)) then return name end
        end

        nil
      end

      def property_value_for(variant)
        variant.send(property_name)
      end

      private

      def variant_model
        @variant_model ||= resource.class.reflect_on_association(relation).klass
      end

      def reflection
        @reflection ||= variant_model.reflect_on_association(property_name)
      end

      def property_used?(property)
        (variants = variants_by_property[property]) && variants.any?
      end

      def variants
        @variants ||= resource.send(relation)
      end

      def variants_by_property
        @variants_by_property ||= variants.each_with_object({}) do |variant, hash|
          if (property = variant.send(property_name))
            hash[property] ||= []
            hash[property] << variant
          end
        end
      end
    end
  end
end
