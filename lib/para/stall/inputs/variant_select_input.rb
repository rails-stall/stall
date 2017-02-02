module Para
  module Stall
    module Inputs
      class VariantSelectInput < SimpleForm::Inputs::Base
        include VariantInputHelper

        attr_reader :relation

        def input(wrapper_options = nil)
          ensure_target_relation_present!

          @relation = options[:relation]

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

        def properties
          @properties ||= options[:properties].map do |property_name, model_name|
            VariantsPropertyConfig.new(
              product,
              property_name,
              relation: relation,
              model_name: model_name,
              variants: variants
            )
          end
        end

        def variants
          @variants ||= options.fetch(:variants, product.send(relation))
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
                data[property_config.property_name] =
                  property_config.property_value_for(variant).id
              end
            end
          end
        end
      end
    end
  end
end
