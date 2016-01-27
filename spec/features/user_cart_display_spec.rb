require 'rails_helper'

RSpec.feature 'The user cart' do
  scenario 'errors if a user adds a product without quantity' do
    book = create(:book, title: 'Alice in wonderland')

    visit books_path

    within(:css, "[data-book-id='#{ book.id }']") do
      find(:css, '[data-quantity-field]').set('0')
      click_on t('stall.line_items.form.add_to_cart')
    end

    expect(page).to have_content(t('stall.line_items.add_error.title'))
  end

  scenario 'shows products added to cart' do
    book = create(:book, title: 'Alice in wonderland')

    visit books_path

    within(:css, "[data-book-id='#{ book.id }']") do
      click_on t('stall.line_items.form.add_to_cart')
    end

    click_on t('stall.line_items.added.view_cart')

    expect(page).to have_content('Alice in wonderland')
  end

  scenario 'allows updating line items quantities' do
    cart, line_item = build_cart_and_line_item

    visit cart_path(cart)

    within(:css, "[data-line-item-id='#{ line_item.id }']") do
      find(:css, '[data-quantity-field]').set('5')
    end

    click_on t('stall.carts.recap.update')

    expect(line_item.reload.quantity).to eq(5)
    expect(page).to have_content(t('stall.carts.flashes.update.success'))
  end

  scenario 'prevents from submitting bad line item quantities, displaying an error message' do
    cart, line_item = build_cart_and_line_item

    visit cart_path(cart)

    within(:css, "[data-line-item-id='#{ line_item.id }']") do
      find(:css, '[data-quantity-field]').set('')
    end

    click_on t('stall.carts.recap.update')

    expect(page).to have_content(t('stall.carts.flashes.update.error'))
  end

  def build_cart_and_line_item
    book = create(:book, title: 'Alice in wonderland')
    line_item = build(:line_item, sellable: book, quantity: 2)
    cart = create(:cart, line_items: [line_item])

    [cart, line_item]
  end
end
