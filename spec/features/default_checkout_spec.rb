require 'rails_helper'

RSpec.feature 'The default cart check out' do
  scenario 'allows to first fill in your informations' do
    cart = build_cart

    visit cart_path(cart)

    click_on t('stall.carts.recap.validate')

    fill_in Customer.human_attribute_name(:email), with: 'test@example.com'

    within(:css, '[data-address-form="shipping"]') do
      fill_in Address.human_attribute_name(:first_name), with: 'Jean'
      fill_in Address.human_attribute_name(:last_name), with: 'Val'
      fill_in Address.human_attribute_name(:address), with: '1 rue de la rue'
      fill_in Address.human_attribute_name(:zip), with: '75001'
      fill_in Address.human_attribute_name(:city), with: 'Paris'
      select 'France', from: Address.human_attribute_name(:country)
    end

    click_on t('stall.checkout.informations.validate')

    expect(page).to have_content t('stall.checkout.shipping_method.title')

    cart.reload
    expect(cart.customer.email).to eq('test@example.com')
    expect(cart.shipping_address.address).to eq('1 rue de la rue')
    expect(cart.billing_address).to eq(cart.shipping_address)
  end

  scenario 'allows to choose a shipping method' do
    create(:shipping_method, name: 'Fake shipping carrier', identifier: 'fake-shipping-calculator')
    cart = build_cart
    cart.customer = build(:customer)
    cart.billing_address = build(:address)
    cart.shipping_address = build(:address)
    cart.state = :shipping_method
    cart.save!

    visit checkout_step_path(cart.wizard.route_key, cart)

    choose 'Fake shipping carrier'

    click_on t('stall.checkout.shipping_method.validate')

    expect(page).to have_content t('stall.checkout.payment_method.title')

    cart.reload
    expect(cart.shipment.shipping_method.name).to eq('Fake shipping carrier')
    expect(cart.shipment.price.to_i).not_to eq(0)
  end

  scenario 'allows to choose a payment method' do
    create(:payment_method, name: 'Fake payment gateway', identifier: 'fake-payment-gateway')
    cart = build_cart
    cart.state = :payment_method
    cart.save!

    visit checkout_step_path(cart.wizard.route_key, cart)

    choose 'Fake payment gateway'

    click_on t('stall.checkout.payment_method.validate')

    expect(page).to have_content t('stall.checkout.payment.title')

    cart.reload
    expect(cart.payment.payment_method.name).to eq('Fake payment gateway')
  end

  def build_cart
    book = create(:book, title: 'Alice in wonderland')
    line_item = build(:line_item, sellable: book, quantity: 2)
    create(:cart, line_items: [line_item])
  end
end
