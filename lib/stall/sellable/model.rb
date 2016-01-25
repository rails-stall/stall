module Stall
  module Sellable
    module Model
      extend ActiveSupport::Concern

      def sellable?
        true
      end

      def to_line_item
        value_if_method = -> name { send(name) if respond_to?(name) }

        Stall::LineItem.new(
          sellable: self,
          quantity: 1,
          name: (value_if_method.(:name) || value_if_method.(:title)),
          unit_price: value_if_method.(:price),
          unit_eot_price: eot_price,
          vat_rate: vat_rate,
        )
      end

      def vat_ratio
        (vat_rate / 100.0) + 1
      end

      private

      def default_eot_price
        price && (price / vat_ratio)
      end

      def default_vat_rate
        @default_vat_rate ||= Stall.config.vat_rate
      end

      def method_missing(name, *args, &block)
        if [:eot_price, :vat_rate].include?(name)
          send(:"default_#{ name }")
        else
          super
        end
      end
    end
  end
end
