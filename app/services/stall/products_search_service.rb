module Stall
  class ProductsSearchService < Stall::BaseService
    attr_reader :products, :params, :search
    alias_method :form, :search

    def initialize(products, params)
      @products = products
      @params = params
    end

    def call
      @search = products.ransack(params[:search] || {})
    end

    def search
      @search || call
    end

    def records
      search.result.distinct
    end
  end
end
