module Stall
  module ProductFilters
    class CategoryFilter < BaseFilter
      def collection
        ProductCategory.roots
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
