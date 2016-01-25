RSpec.shared_examples 'a sellable model' do |factory|
  it 'includes the Stall::Sellable::Model mixin' do
    expect(build(factory).class.ancestors).to include(Stall::Sellable::Model)
  end

  it 'is marked as sellable' do
    expect(build(factory).sellable?).to eq(true)
  end

  describe '#to_line_item' do
    it 'returns a line_item' do
      sellable = build(factory)
      expect(sellable.to_line_item.class.name).to eq(Stall::LineItem.name)
    end

    it 'needs minimal data on the sellable to produce a valid line item' do
      line_item = build(factory).to_line_item
      expect(line_item.save).to eq(true)
    end
  end
end
