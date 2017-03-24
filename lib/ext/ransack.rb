module Stall
  module Ransack
    def self.configure
      ::Ransack.configure do |config|
        config.add_predicate 'between_cents',
          arel_predicate: 'between',
          formatter: proc { |v| Range.new(*v.split(',').map { |s| (s.to_i * 100) }) },
          validator: proc { |v| v.present? },
          type: :string
      end
    end
  end
end
