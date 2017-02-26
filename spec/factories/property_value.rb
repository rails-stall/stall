FactoryGirl.define do
  factory :property_value do
    name 'Black'
    property { build(:property) }
  end
end
