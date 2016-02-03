require 'rails_helper'

RSpec.describe Stall::Shipping::Calculator do
  describe '.register' do
    it 'allows registering a calculator to the global calculators hash' do
      Stall::Shipping::Calculator.register('fake')
      expect(Stall::Shipping.calculators['fake']).to eq(Stall::Shipping::Calculator)
    end
  end

  describe '#available?' do
    it 'raises when not overriden' do
      calculator = Stall::Shipping::Calculator.new(double(:cart), double(:config))
      expect { calculator.available? }.to raise_error(NoMethodError)
    end
  end

  describe '#price' do
    it 'raises when not overriden' do
      calculator = Stall::Shipping::Calculator.new(double(:cart), double(:config))
      expect { calculator.price }.to raise_error(NoMethodError)
    end
  end
end
