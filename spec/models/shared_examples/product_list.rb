RSpec.shared_examples 'a product list' do |factory|
  it { should validate_presence_of(:type) }

  it { should have_many(:line_items).dependent(:destroy) }

  it { should belong_to(:customer) }

  it 'sets its currency to the default Money one on initialization' do
    expect(Stall::ProductList.new.currency).to eq(Money.default_currency)
  end

  it 'sets its state to the first wizard step on initialization' do
    expect(Stall::ProductList.new.state).to eq(DefaultCheckoutWizard.steps.first)
  end

  it 'generates a token on creation' do
    list = create(factory, token: nil)
    expect(list.token).not_to be_nil
  end

  describe '#total_price' do
    it 'returns the total line items price' do
      line_item1 = build(:line_item, price: 100)
      line_item2 = build(:line_item, price: 200)
      list = build(factory, line_items: [line_item1, line_item2])

      expect(list.total_price.to_f).to eq(300.0)
    end
  end

  describe '#total_eot_price' do
    it 'returns the total line items eot_price' do
      line_item1 = build(:line_item, eot_price: 100)
      line_item2 = build(:line_item, eot_price: 200)
      list = build(factory, line_items: [line_item1, line_item2])

      expect(list.total_eot_price.to_f).to eq(300.0)
    end
  end

  describe '#total_vat' do
    it 'returns the total line items vat' do
      line_item1 = build(:line_item, eot_price: 100, price: 120)
      line_item2 = build(:line_item, eot_price: 200, price: 240)
      list = build(factory, line_items: [line_item1, line_item2])

      expect(list.total_vat.to_f).to eq(60.0)
    end
  end

  describe '#total_quantity' do
    it 'returns the total line items quantity' do
      line_item1 = build(:line_item, quantity: 1)
      line_item2 = build(:line_item, quantity: 2)
      list = build(factory, line_items: [line_item1, line_item2])

      expect(list.total_quantity).to eq(3)
    end
  end


  describe '#state' do
    it 'returns the state attribute as a symbol' do
      list = build(factory)
      list.state = 'foo'
      expect(list.state).to eq(:foo)
    end
  end

  describe '#reset_state!' do
    it 'resets the state to the first wizard step and persists the change' do
      list = create(factory, state: :payment)
      list.reset_state!
      expect(list.reload.state).to eq(:informations)
    end
  end

  describe '#to_param' do
    it 'returns the list token, making serialization key be its token' do
      list = create(factory)
      expect(list.to_param).to eq(list.token)
    end
  end

  describe '#total_quantity' do
    it 'returns the total items quantity of the list' do
      list = create(factory)
      list.line_items = [
        create(:line_item, quantity: 2),
        create(:line_item, quantity: 3)
      ]

      expect(list.total_quantity).to eq(5)
    end
  end

  describe '#wizard' do
    it 'returns a wizard instance by default, with the Default generated wizard' do
      list = create(factory)

      expect(list.wizard).to eq(DefaultCheckoutWizard)
    end

    it 'raises if no wizard was found' do
      with_config :default_checkout_wizard, 'foo' do
        expect { create(factory) }.to raise_error(Stall::Checkout::WizardNotFoundError)
      end
    end
  end
end
