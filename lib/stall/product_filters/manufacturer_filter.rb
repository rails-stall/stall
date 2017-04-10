module Stall
  module ProductFilters
    class ManufacturerFilter < BaseFilter
      def available?
        options[:force] || collection.count > 1
      end

      def collection
        @collection ||= Manufacturer.ordered.joins(:products)
          .where(stall_products: { id: products.select(:id) })
          .distinct
      end

      def param
        :manufacturer_id_in
      end
    end
  end
end
