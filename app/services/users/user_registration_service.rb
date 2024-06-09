# frozen_string_literal: true

module Users
  class UserRegistrationService
    def self.call(user)
      return unless user.persisted?

      ClientMailer.new_client_email(user).deliver_now
    end
  end
end
