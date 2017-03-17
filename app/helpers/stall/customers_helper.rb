module Stall
  module CustomersHelper
    # Copy e-mail error messages from user to customer, allowing them to be
    # displayed in customer e-mail input to the visitor
    #
    def with_errors_from_user(customer)
      return customer unless (user = customer.user) && user.errors.any?
      return unless (messages = user.errors.messages[:email]) && messages.any?

      messages.each do |message|
        customer.errors.add(:email, message)
      end

      customer
    end
  end
end
