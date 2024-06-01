# frozen_string_literal: true

class AppointmentMailer < ApplicationMailer
  default from: 'Booking-app.com'

  def new_appointment_email(user)
    @user = user
    @appointment = Appointment.where(client_id: user.id)
                              .or(Appointment.where(freelancer_id: user.id))
                              .order(created_at: :desc).first
    mail(to: user.email, subject: 'Booking-app New Appointment!')
  end
end
