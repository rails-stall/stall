module Stall
  module ProductFilters
    extend ActiveSupport::Autoload

    autoload :Builder
    autoload :BaseFilter
    autoload :CategoryFilter
    autoload :ManufacturerFilter
    autoload :PriceFilter
    autoload :PropertyFilter
  end
end
