module Stall
  module Models
    module ProductDetail
      extend ActiveSupport::Concern

      included do
        self.table_name = 'stall_product_details'

        acts_as_orderable

        belongs_to :product

        validates :name, presence: true
      end
    end
  end
end
