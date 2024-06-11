# frozen_string_literal: true

module Appointments
  class FetchAppointments
    def self.call(user)
      if user.freelancer?
        Appointment.where(freelancer_id: user.id)
                   .order(:start)
      else
        Appointment.where(client_id: user.id)
                   .order(:start)
      end
    end
  end
end
