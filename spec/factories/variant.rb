FactoryGirl.define do
  factory :variant do
    name 'Test T-shirt - Red / 10'
    price 10
    product { build(:product) }
  end
end
