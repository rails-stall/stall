class FakePaymentGateway < Stall::Payments::Gateway
  register 'fake-payment-gateway'

  def self.request(cart)
    Request.new(cart)
  end

  def self.response(request)
    Response.new(request)
  end

  class Request
    attr_reader :cart

    def initialize(cart)
      @cart = cart
    end

    def payment_form_partial_path
      'fake_payment_gateway/payment_form'
    end
  end

  class Response
    attr_reader :request, :cart

    def initialize(request)
      @request = request
      @cart = Cart.find(request.params[:cart_id])
    end

    def notify
      cart.payment.pay! if request.params[:success]
    end

    def valid?
      request.params[:valid]
    end
  end
end
