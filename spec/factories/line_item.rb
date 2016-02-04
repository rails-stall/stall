FactoryGirl.define do
  factory :line_item do
    name 'Product Test'
    unit_eot_price 10
    unit_price 12
    vat_rate 20.0
    quantity 1
    sellable { build(:sellable) }
  end
end
