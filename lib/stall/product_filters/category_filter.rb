module Stall
  module ProductFilters
    class CategoryFilter < BaseFilter
      def available?
        collection.count > 1
      end

      def collection
        @collection ||= ProductCategory.joins(:products)
          .where(stall_products: { id: products.select(:id) })
          .uniq
      end

      def param
        :"#{ param_with_parents }_in"
      end

      private

      def param_with_parents
        ProductCategory.max_depth.times.map do |index|
          parents_string = index.times.map { 'parent' }.join('_').presence
          ['product_category', parents_string, 'id'].compact.join('_')
        end.join('_or_')
      end
    end
  end
end
