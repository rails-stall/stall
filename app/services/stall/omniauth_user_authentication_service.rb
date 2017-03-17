module Stall
  class OmniauthUserAuthenticationService < Stall::BaseService
    attr_reader :email, :auth

    def initialize(email, auth)
      @email = email
      @auth = auth
    end

    def call
      if existing_user
        ensure_omniauth_account!(existing_user, auth)
        existing_user
      else
        create_user_from_auth!
      end
    end

    private

    def ensure_omniauth_account(user, auth)
      account = user.user_omniauth_accounts.find { |account| account.provider == auth.provider }
      return account if account

      user.user_omniauth_accounts.build(provider: auth.provider, uid: auth.uid)
    end

    def ensure_omniauth_account!(user, auth)
      ensure_omniauth_account(user, auth)
      user.save!
    end

    def existing_user
      @existing_user ||= User.joins(:user_omniauth_accounts).where(
        '(stall_user_omniauth_accounts.provider = ? AND stall_user_omniauth_accounts.uid = ?) OR stall_users.email = ?',
        auth.provider, auth.uid, email
      ).first
    end

    def create_user_from_auth!
      User.create! do |user|
        user.email = email
        user.password = Devise.friendly_token
        ensure_omniauth_account(user, auth)
      end
    end
  end
end
