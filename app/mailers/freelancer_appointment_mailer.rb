# frozen_string_literal: true

class FreelancerAppointmentMailer < ApplicationMailer
  default from: 'Booking-app.com'

  def new_appointment_mail_to_freelancer(appointment)
    @appointment = appointment
    @freelancer = User.find(appointment.freelancer_id)
    mail(to: @freelancer.email, subject: 'Booking-app New Appointment!')
  end
end
