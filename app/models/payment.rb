class Payment < ActiveRecord::Base
  include Stall::Models::Payment
end
