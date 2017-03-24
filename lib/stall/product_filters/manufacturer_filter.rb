module Stall
  module ProductFilters
    class ManufacturerFilter < BaseFilter
      def available?
        collection.count > 1
      end

      def collection
        @collection ||= Manufacturer.ordered.joins(:products)
          .where(stall_products: { id: products.select(:id) })
          .uniq
      end

      def param
        :manufacturer_id_in
      end
    end
  end
end
