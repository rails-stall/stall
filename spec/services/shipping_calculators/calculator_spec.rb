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

  describe '#eot_price' do
    it 'returns the calculator eot price' do
      calculator = Stall::Shipping::Calculator.new(double(:cart), double(:config))
      allow(calculator).to receive(:price).and_return(120)
      allow(calculator).to receive(:vat_rate).and_return(20)

      expect(calculator.eot_price).to eq(100)
    end
  end

  describe '#vat_rate' do
    it 'defaults to the default Stall vat rate' do
      calculator = Stall::Shipping::Calculator.new(double(:cart), double(:config))

      expect(calculator.vat_rate).to eq(Stall.config.vat_rate)
    end
  end
end
