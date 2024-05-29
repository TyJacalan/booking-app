# frozen_string_literal: true

class ClientMailer < ApplicationMailer
  default from: 'Booking-app.com'

  def new_client_email(user)
    @user = user
    mail(to: user.email, subject: 'Booking-app Welcomes you!')
  end
end
