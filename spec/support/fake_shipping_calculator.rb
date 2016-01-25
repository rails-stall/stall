# This fake CountryWeightTableCalculator subclass allows us to load a fake CSV
# to test shipping fee calculation for the CountryWeightTableCalculator class
# and for integration tests
#
class FakeShippingCalculator < Stall::Shipping::CountryWeightTableCalculator
  register 'fake-shipping-calculator'

  def load_data
    @load_data ||= load_from <<-CSV.strip
,"FR,MC,AD","GB,GR,RO,SM,VA"
0.5,5.7,8.45
1,7.1,12.7
2,8.2,17.35
    CSV
  end
end
