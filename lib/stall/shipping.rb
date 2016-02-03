module Stall
  module Shipping
    extend ActiveSupport::Autoload

    autoload :Calculator

    autoload :CountryWeightTableCalculator
    autoload :FreeShippingCalculator

    autoload :Config

    mattr_reader :calculators
    @@calculators = {}.with_indifferent_access
  end
end

