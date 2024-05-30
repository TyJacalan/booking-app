# frozen_string_literal: true

module Appointments
  class CreateAppointment
    def self.call(appointment)
      ActiveRecord::Base.transaction do
        return false unless appointment.save

        Notifications::CreateNotification.notify_new_appointment(appointment)

        payment_intent = Paymongo::PaymentIntents.create(appointment.fee_in_cents)
        appointment.payment_intent_id = payment_intent[:id]
        appointment.save

        true
      end
    end
  end
end
