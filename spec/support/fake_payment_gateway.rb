class FakePaymentGateway < Stall::Payments::Gateway
  register 'fake-payment-gateway'

  def process_payment_for(request)
    if request.params[:success]
      cart.payment.pay!
    end
  end
end
