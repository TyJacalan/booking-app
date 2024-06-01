# Preview all emails at http://localhost:3000/rails/mailers/appointment_mailer
class AppointmentMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/appointment_mailer/new_appointment_email
  def new_appointment_email
    AppointmentMailer.new_appointment_email
  end
end
