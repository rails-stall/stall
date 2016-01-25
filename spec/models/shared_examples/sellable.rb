RSpec.shared_examples 'a sellable model' do |factory|
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
