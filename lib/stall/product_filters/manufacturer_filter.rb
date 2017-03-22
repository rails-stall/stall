module Stall
  module ProductFilters
    class ManufacturerFilter < BaseFilter
      def collection
        Manufacturer.ordered
      end

      def param
        :manufacturer_id_in
      end
    end
  end
end
