module Stall
  module ProductFilters
    class PriceFilter < BaseFilter
      def min
        return 0 unless variants.any?
        variants.order(price_cents: :asc).first.price.to_d.floor
      end

      def max
        return 0 unless variants.any?
        variants.order(price_cents: :desc).first.price.to_d.ceil
      end

      def param
        :variants_price_cents_between_cents
      end

      private

      def variants
        @variants ||= Variant.where(product: products)
      end
    end
  end
end
