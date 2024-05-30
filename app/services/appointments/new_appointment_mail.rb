# frozen_string_literal: true

module Appointments
  class NewAppointmentMail
    def self.call(user)
      return unless user.persisted?

      AppointmentMailer.new_appointment_email(user).deliver_now
    end
  end
end
