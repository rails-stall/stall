require 'rails_helper'

class FakeDefaultCheckoutWizard < Stall::Checkout::Wizard
  steps :step1, :step2, :step3
end

RSpec.describe Stall::Checkout::Wizard do
  describe '.steps' do
    it 'allows subclasses to define the checkout wizard steps when passed arguments' do
      expect(FakeDefaultCheckoutWizard._steps).to eq([:step1, :step2, :step3])
    end

    it 'returns the current steps when no arguments are passed' do
      expect(FakeDefaultCheckoutWizard.steps).to eq([:step1, :step2, :step3])
    end
  end

  describe '.route_key' do
    it 'returns a clean route key for URL serialization' do
      expect(FakeDefaultCheckoutWizard.route_key).to eq('fake-default')
    end
  end

  describe '.from_route_key' do
    it 'returns a wizard from a given route key' do
      wizard = Stall::Checkout::Wizard.from_route_key('fake-default')
      expect(wizard).to eq(FakeDefaultCheckoutWizard)
    end
  end

  describe '#current_step_name' do
    it 'returns the current checkout wizard step depending on the cart state' do
      cart = build(:cart, state: :step3)
      wizard = FakeDefaultCheckoutWizard.new(cart)

      expect(wizard.current_step_name).to eq(:step3)
    end

    it 'raises if the state is out of range for the wizard' do
      cart = build(:cart, state: :undefined)
      wizard = FakeDefaultCheckoutWizard.new(cart)

      expect { wizard.current_step_name }.to raise_error(Stall::Checkout::Wizard::StepUndefinedError)
    end
  end

  describe '#next_step' do
    it 'returns the next step for the current cart' do
      cart = build(:cart, state: :step2)
      wizard = FakeDefaultCheckoutWizard.new(cart)

      expect(wizard.next_step_name).to eq(:step3)
    end

    it 'returns nil if there is not next step' do
      cart = build(:cart, state: :step3)
      wizard = FakeDefaultCheckoutWizard.new(cart)

      expect(wizard.next_step_name).to eq(nil)
    end
  end

  describe '#complete?' do
    it 'returns true if there is no next step' do
      cart = build(:cart, state: :step3)
      wizard = FakeDefaultCheckoutWizard.new(cart)

      expect(wizard.complete?).to eq(true)
    end

    it 'returns false if there is a next step' do
      cart = build(:cart, state: :step2)
      wizard = FakeDefaultCheckoutWizard.new(cart)

      expect(wizard.complete?).to eq(false)
    end
  end

  describe '#steps_count' do
    it 'returns the steps count' do
      cart = build(:cart)
      wizard = FakeDefaultCheckoutWizard.new(cart)

      expect(wizard.steps_count).to eq(3)
    end
  end
end
