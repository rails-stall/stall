RSpec.shared_examples 'an addressable model' do |factory|
  it { should have_one(:billing_address) }
  it { should have_one(:shipping_address) }
end
