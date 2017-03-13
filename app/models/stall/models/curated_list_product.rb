module Stall
  module Models
    module CuratedListProduct
      extend ActiveSupport::Concern

      included do
        self.table_name = 'stall_curated_list_products'
        acts_as_orderable

        belongs_to :product
        belongs_to :curated_product_list
      end
    end
  end
end
