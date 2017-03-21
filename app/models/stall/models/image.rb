module Stall
  module Models
    module Image
      extend ActiveSupport::Concern

      included do
        self.table_name = 'stall_images'

        acts_as_orderable

        belongs_to :imageable, polymorphic: true

        has_attached_file :file, styles: {
          thumb: '100x100#',
          show: '555x'
        }
        validates_attachment :file, content_type: { content_type: /\Aimage\/.*\z/ }
      end
    end
  end
end
