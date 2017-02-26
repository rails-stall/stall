require 'rails_helper'

RSpec.feature 'The checkout credit usage feature' do
  include ActionView::Helpers::NumberHelper

  scenario 'allows users with credit to use it and remove it from the cart' do
    customer = sign_in_customer
    first_credit_note = customer.credit_notes.create!(amount: 30)
    second_credit_note = customer.credit_notes.create!(amount: 20)

    cart = create_filled_cart(price: 100)

    visit checkout_path(cart_key: cart.identifier)

    # Use credit from available credit notes
    within(:css, '[data-cart-credit-form]') do
      expect(find('[data-cart-credit-input]').value).to eq('50.0')

      fill_in 'amount', with: 40

      click_on t('stall.credit_notes.usage_form.use_my_credit')
    end

    expect(page).to have_content(total_price_string(60))

    expect(first_credit_note.reload.remaining_amount).to eq(0)
    expect(second_credit_note.reload.remaining_amount).to eq(Money.new(1000, currency))

    # Remove credit usage from cart
    click_on t('stall.credit_notes.usage_form.remove_credit_usage')

    expect(page).to have_content(total_price_string(100))

    expect(first_credit_note.reload.remaining_amount).to eq(Money.new(3000, currency))
    expect(second_credit_note.reload.remaining_amount).to eq(Money.new(2000, currency))
  end

  private

  def sign_in_customer
    create(:customer, user: build(:user)).tap do |customer|
      sign_in(customer.user)
    end
  end

  def create_filled_cart(price: nil)
    book = create(:book, title: 'Alice in wonderland', price: price)

    visit books_path

    within(:css, "[data-book-id='#{ book.id }']") do
      click_on t('stall.line_items.form.add_to_cart')
    end

    token = find(:xpath, '//div[@data-cart-token]')['data-cart-token']
    Cart.find_by_token!(token)
  end

  def total_price_string(price)
    total_price_string = [
      t('stall.carts.recap.total_price'),
      number_to_currency(Money.new(price * 100, currency))
    ].join(' ')
  end

  def currency
    Stall.config.default_currency
  end
end
