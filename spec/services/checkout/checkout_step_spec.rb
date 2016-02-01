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

  describe '#inject' do
    it 'allows injecting dependencies to the current step instance' do
      step = Stall::Checkout::Step.new(double(:cart))
      step.inject(:foo, 'bar')
      expect(step.foo).to eq('bar')
    end
  end

  describe '.validations' do
    it 'allows to build validations for the given step when given a block' do
      with_config FakeCheckoutStep, :validations, proc { validates :customer, presence: true } do
        expect(FakeCheckoutStep.validations).not_to be_nil
      end
    end
  end
end
