require 'rails_helper'

RSpec.describe Stall::PaymentsController do
  describe '#notify' do
    it 'delegates processing to the appropriate payment notification service' do
      service = double(:payment_notification_service, call: true, rendering_options: { nothing: true })
      allow(Stall::PaymentNotificationService).to receive(:new).and_return(service)

      expect(service).to receive(:call)

      get :notify, gateway: 'fake-payment-gateway'

      expect(response.status).to eq(200)
      expect(response.body).to eq('')
    end
  end
end
