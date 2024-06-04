# frozen_string_literal: true

module Appointments
  class FetchAppointments
    def self.call(user)
      Appointment.includes(:freelancer, :service)
                 .where(client_id: user.id)
                 .or(Appointment.where(freelancer_id: user.id))
                 .order(:start)
    end
  end
end
