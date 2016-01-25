require 'rails_helper'

RSpec.describe Stall::Shipping::FreeShippingCalculator do
  describe '#price' do
    it 'returns 0' do
      calculator = build_calculator

      expect(calculator.price).to eq(0)
    end
  end

  describe '#available_for?' do
    context 'when not configured' do
      it 'returns true' do
        calculator = build_calculator

        expect(calculator.available_for?(build(:address))).to eq(true)
      end
    end

    context 'when configured with a countries list' do
      before(:all) do
        Stall.config.shipping.free_shipping.available = ['FR', 'GB']
      end

      it 'returns true if the country is in the list' do
        calculator = build_calculator
        address = build(:address, country: 'FR')

        expect(calculator.available_for?(address)).to eq(true)
      end

      it 'returns false if the country is not in the list' do
        calculator = build_calculator
        address = build(:address, country: 'DE')

        expect(calculator.available_for?(address)).to eq(false)
      end
    end

    context 'when configured with a proc' do
      before(:all) do
        Stall.config.shipping.free_shipping.available = -> address do
          address.country == 'FR'
        end
      end

      it 'returns true if the proc returns true' do
        calculator = build_calculator
        address = build(:address, country: 'FR')

        expect(calculator.available_for?(address)).to eq(true)
      end

      it 'returns false if the proc returns false' do
        calculator = build_calculator
        address = build(:address, country: 'GB')

        expect(calculator.available_for?(address)).to eq(false)
      end
    end
  end

  def build_calculator
    Stall::Shipping::FreeShippingCalculator.new(
      build(:cart),
      build(:shipping_method)
    )
  end
end
