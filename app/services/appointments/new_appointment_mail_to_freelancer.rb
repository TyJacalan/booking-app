# frozen_string_literal: true

module Appointments
  class NewAppointmentMailToFreelancer
    def self.call(appointment)
      return unless appointment.persisted?

      FreelancerAppointmentMailer.new_appointment_mail_to_freelancer(appointment).deliver_now
    end
  end
end
