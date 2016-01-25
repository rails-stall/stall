require 'rails_helper'

class FakeCheckoutStep < Stall::Checkout::Step
end

RSpec.describe Stall::Checkout::Step do
  describe '.for' do
    it 'allows fetching a step for a given step symbol' do
      expect(Stall::Checkout::Step.for(:fake)).to eq(FakeCheckoutStep)
    end

    it 'falls back to the Stall::Checkout namespace if no app specific step is found' do
      expect(Stall::Checkout::Step.for(:informations)).to eq(Stall::Checkout::InformationsCheckoutStep)
    end

    it 'raises if no step was found' do
      expect { Stall::Checkout::Step.for(:undefined) }.to raise_error(Stall::Checkout::StepNotFoundError)
    end
  end
end
