module Stall
  class Customer < ActiveRecord::Base
    include Stall::Addressable
  end
end
