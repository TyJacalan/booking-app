# frozen_string_literal: true

module Appointments
  class UpdateAppointment
    def self.call(appointment, user, params)
      ActiveRecord::Base.transaction do
        return false unless appointment.update(params)

        Notifications::CreateNotification.notify_updated_appointment(appointment, user)

        true
      end
    end
  end
end
