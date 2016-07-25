require 'rails_helper'

RSpec.describe Stall::Payments::Config do
  let(:config) { Stall::Payments::Config.new }

  describe '#register_gateway' do
    it 'allows registering a payment gateway' do
      gateway = double('fake_gateway')
      config.register_gateway('fake_gateway', gateway)
      expect(Stall::Payments.gateways['fake_gateway']).to eq(gateway)
    end
  end

  describe '#configure' do
    it 'allows configuring stall payments with a block' do
      config.configure do |configuration|
        expect(configuration).to eq(config)
      end
    end
  end

  describe '#configure_urls' do
    it 'allows setting payment methods recall URLs' do
      urls_block = -> { ['urls'] }
      config.configure_urls(&urls_block)
      expect(Stall::Payments::UrlsConfig.config_block).to eq(urls_block)
    end
  end

  describe '#method_missing' do
    it 'allows getting a gateway by its identifier' do
      gateway = double('fake_gateway')
      config.register_gateway('fake_gateway', gateway)
      expect(config.fake_gateway).to eq(gateway)
    end

    it 'allows configure a gateway by its identifier when given a block' do
      gateway = double('fake_gateway')
      config.register_gateway('fake_gateway', gateway)

      config.fake_gateway do |fake_gateway|
        expect(fake_gateway).to eq(gateway)
      end
    end

    it 'raises when no gateway with the given identifier is found' do
      expect { config.unexisting_gateway }.to raise_error(NoMethodError)
    end
  end
end
