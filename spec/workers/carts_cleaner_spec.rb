require 'rails_helper'
require 'stall/carts_cleaner'

RSpec.describe Stall::CartsCleaner do
  describe '#initialize' do
    it 'allows setting the cart model that will be cleaned' do
      expect(ProductList).to receive(:empty).and_return(ProductList.empty)
      Stall::CartsCleaner.new(ProductList).clean!
    end
  end

  describe '#clean!' do
    it 'cleans empty carts older than the expiration delay' do
      with_config :empty_carts_expires_after, 0.seconds do
        cart = create(:cart)
        Stall::CartsCleaner.new(Cart).clean!
        expect { cart.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    it 'does not clean empty carts younger than the expiration delay' do
      with_config :empty_carts_expires_after, 1.hour do
        cart = create(:cart)
        Stall::CartsCleaner.new(Cart).clean!
        expect { cart.reload }.not_to raise_error
      end
    end

    it 'cleans aborted carts older than the expiration delay' do
      with_config :aborted_carts_expires_after, 0.seconds do
        cart = create(:cart, line_items: [build(:line_item)])
        Stall::CartsCleaner.new(Cart).clean!
        expect { cart.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    it 'does not clean aborted carts younger than the expiration delay' do
      with_config :aborted_carts_expires_after, 1.hour do
        cart = create(:cart, line_items: [build(:line_item)])
        Stall::CartsCleaner.new(Cart).clean!
        expect { cart.reload }.not_to raise_error
      end
    end
  end
end
