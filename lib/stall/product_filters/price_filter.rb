module Stall
  module ProductFilters
    class PriceFilter < BaseFilter
      def available?
        options[:force] || min != max
      end

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

      def ticks
        min_tick = (min / 10.0).floor
        max_tick = (max / 10.0).ceil
        ticks_count = 4

        (ticks_count + 1).times.map do |index|
          ((((max_tick - min_tick) / ticks_count.to_f) * index) + min_tick).to_i * 10
        end
      end

      private

      def variants
        @variants ||= Variant.where(product: products)
      end
    end
  end
end
