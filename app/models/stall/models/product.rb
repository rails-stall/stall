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

        has_many :images, -> { ordered },  as: :imageable

        has_many :curated_list_products, dependent: :destroy
        has_many :curated_product_lists, through: :curated_list_products

        accepts_nested_attributes_for :images, allow_destroy: true

        validates :name, presence: true

        scope :visible, -> { where(visible: true) }
      end

      def vat_rate
        read_attribute(:vat_rate).presence || Stall.config.vat_rate
      end

      def price
        variants.map(&:price).min
      end

      def image(*args)
        if (image = images.first)
          image.file
        end
      end

      # Support paperclip attachment presence helper for #image
      def image?
        !!image
      end
    end
  end
end
