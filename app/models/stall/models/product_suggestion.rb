module Stall
  module Models
    module ProductSuggestion
      extend ActiveSupport::Concern

      included do
        self.table_name = 'stall_product_suggestions'

        belongs_to :product
        belongs_to :suggestion, class_name: 'Product'
      end
    end
  end
end
