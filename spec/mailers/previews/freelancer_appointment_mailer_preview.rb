# Preview all emails at http://localhost:3000/rails/mailers/freelancer_appointment_mailer
class FreelancerAppointmentMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/freelancer_appointment_mailer/freelancer_new_appointment_email
  def freelancer_new_appointment_email
    FreelancerAppointmentMailer.freelancer_new_appointment_email
  end

end
