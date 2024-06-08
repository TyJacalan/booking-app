# frozen_string_literal: true

module Appointments
  class FetchAppointments
    def self.call(user)
      if user.freelancer?
        user.freelancer_appointments.order(:start)
      else
        user.client_appointments.order(:start)
      end
    end
  end
end
