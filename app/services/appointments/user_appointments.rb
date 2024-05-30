## frozen_string_literal: true

module Appointments
  class UserAppointments
    def self.fetch(user)
      Appointment.where(client_id: user.id)
                 .or(Appointment
                 .where(freelancer_id: user.id))
                 .order(:start)
    end
  end
end
