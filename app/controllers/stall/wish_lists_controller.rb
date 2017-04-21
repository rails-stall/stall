module Stall
  class WishListsController < Stall::ApplicationController
    def show
      @wish_list = current_customer.wish_lists.find_by_token(params[:id])
    end
  end
end
