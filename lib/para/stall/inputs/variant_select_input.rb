module Para
  module Stall
    module Inputs
      class VariantSelectInput < SimpleForm::Inputs::Base
        include VariantInputHelper

        def input(wrapper_options = nil)
          ensure_target_relation_present!

          template.render partial: partial_path, locals: {
            form: @builder,
            model: model,
            attribute_name: attribute_name,
            foreign_key: foreign_key,
            properties: properties,
            variants_data: variants_data,
            price_selector: price_selector
          }
        end

        private

        def price_selector
          @price_selector ||= options[:price_selector] || '[data-sellable-price]'
        end

        def product
          @product ||= options[:product]
        end

        def relation
          @relation ||= options.fetch(:relation, :variants)
        end

        # Iterate on every variant to fetch available properties and values and
        # build a VariantsPropertyConfig for each available one
        #
        def properties
          @properties ||= variants.each_with_object({}) do |variant, hash|
            variant.variant_property_values.each do |variant_property_value|
              property = variant_property_value.property_value.property

              unless hash[property]
                hash[property] = VariantsPropertyConfig.new(
                  product, property, variants
                )
              end
            end
          end.values
        end

        def variants
          @variants ||= options.fetch(:variants) do
            product.variants.select(&:published?)
          end
        end

        def partial_path
          options.fetch(:partial_path, 'para/stall/inputs/variant_select')
        end

        def foreign_key
          @foreign_key ||= model.reflect_on_association(attribute_name).foreign_key
        end

        def variants_data
          @variants_data ||= variants.map do |variant|
            { id: variant.id, price: template.number_to_currency(variant.price) }.tap do |data|
              properties.each do |property_config|
                data[property_config.property.id] =
                  property_config.property_value_for(variant).id
              end
            end
          end
        end
      end
    end
  end
end
