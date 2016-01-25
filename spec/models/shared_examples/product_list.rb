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
  end
end
