class UserMailer < ApplicationMailer
    def review_notification(user, appointment)
      @user = user
      @appointment = appointment
      mail(to: @user.email, subject: 'Please review your recent appointment')
    end
end