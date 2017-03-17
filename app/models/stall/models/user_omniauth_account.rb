module Stall
  module Models
    module UserOmniauthAccount
      extend ActiveSupport::Concern

      included do
        self.table_name = 'stall_user_omniauth_accounts'

        belongs_to :user
      end
    end
  end
end
