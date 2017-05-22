require 'csv'

module Stall
  module Shipping
    class CountryWeightTableCalculator < Stall::Shipping::Calculator
      def available?
        country?(address.country)
      end

      def price
        # Convert weight from grams to kilograms.
        total_weight = (cart.total_weight / 1000.0)

        # Browse the data hash to find a suitable country code for the cart's
        # total weight
        if (prices = data[cart.shipping_address.country])
          prices.each do |max_weight, price|
            return price if total_weight < max_weight
          end
        end

        # Return nil if no price was found
        nil
      end

      private

      def country?(country)
        countries.include?(country)
      end

      def countries
        @countries ||= data.keys
      end

      def data
        @data ||= load_data
      end

      def load_data
        raise NoMethodError,
          'CountryWeightTableCalculator subclasses must implement the ' \
          '#load_data method and return a two dimensional array with ' \
          'countries as the first line and weight and prices on the other ' \
          'lines'
      end

      def load_from(csv_string)
        csv = CSV.parse(csv_string)
        headers = csv.shift

        headers.each_with_index.each_with_object({}) do |(countries, index), hash|
          # Skip first empty cell of the countries row
          next if index == 0

          countries.split(",").each do |country|
            country_code = country.strip
            hash[country_code] = {}

            csv.each do |row|
              max_weight = row.first.to_f
              price = BigDecimal.new(row[index]) if row[index]
              hash[country_code][max_weight] = price
            end
          end
        end
      end
    end
  end
end
