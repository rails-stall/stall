module Stall
  class CartsController < Stall::ApplicationController
    before_action :load_cart

    def show
    end

    def update
      respond_to do |format|
        service = Stall::CartUpdateService.new(@cart, cart_params)

        if service.call
          format.html.xhr do
            render 'show'
          end

          format.html.any do
            flash[:success] = t('stall.carts.flashes.update.success')
            redirect_to cart_path(@cart)
          end
        else
          format.html.xhr do
            render 'show'
          end

          format.html.any do
            flash[:error] = t('stall.carts.flashes.update.error')
            render 'show'
          end
        end
      end
    end

    private

    def load_cart
      @cart = ProductList.find_by_token(params[:id])
    end

    def cart_params
      params.require(:cart).permit(
        line_items_attributes: [
          :id, :quantity, :_destroy
        ]
      )
    end
  end
end
