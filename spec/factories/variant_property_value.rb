FactoryGirl.define do
  factory :variant_property_value do
    property_value { build(:property_value) }
    variant { build(:variant) }
  end
end
