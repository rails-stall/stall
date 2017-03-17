module Stall
  module Models
    module User
      extend ActiveSupport::Concern

      included do
        self.table_name = 'stall_users'

        devise :database_authenticatable, :registerable, :recoverable,
               :rememberable, :trackable, :validatable, :omniauthable,
               omniauth_providers: Stall.config.omniauth_providers.map(&:name)

        has_one :customer, as: :user, dependent: :nullify
        has_many :user_omniauth_accounts, dependent: :destroy
      end
    end
  end
end
