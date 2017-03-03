module Stall
  module Models
    module Product
      extend ActiveSupport::Concern

      included do
        self.table_name = 'stall_products'

        acts_as_orderable
        extend FriendlyId
        friendly_id :name, use: [:slugged, :finders]

        belongs_to :product_category
        belongs_to :manufacturer

        has_many :variants, dependent: :destroy, inverse_of: :product
        accepts_nested_attributes_for :variants, allow_destroy: true

        has_many :product_details, -> { ordered }, dependent: :destroy,
                                                   inverse_of: :product
        accepts_nested_attributes_for :product_details, allow_destroy: true

        has_many :product_suggestions, dependent: :destroy
        has_many :suggested_products, through: :product_suggestions,
                                      source: :suggestion

        has_many :suggester_product_suggestions, dependent: :destroy,
                                                 foreign_key: :suggestion_id,
                                                 class_name: 'ProductSuggestion'
        has_many :suggester_products, through: :suggester_product_suggestions,
                                      source: :product

        has_attached_file :image, styles: {
          thumb: '100x100#',
          show: '555x'
        }
        validates_attachment :image, content_type: { content_type: /\Aimage\/.*\z/ }

        validates :name, presence: true

        scope :visible, -> { where(visible: true) }
      end

      def vat_rate
        Stall.config.vat_rate
      end

      def price
        variants.map(&:price).min
      end
    end
  end
end
