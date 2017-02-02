module Stall
  module ReferenceManager
    extend ActiveSupport::Concern

    included do
      after_save :ensure_reference, on: :create
    end

    def ensure_reference
      unless reference.present?
        reference = [Time.now.strftime('%Y%m%d'), ('%05d' % id)].join('-')
        self.reference = reference
        save(validate: false) unless new_record?
      end
    end
  end
end
