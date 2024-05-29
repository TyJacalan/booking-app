# frozen_string_literal: true

module Appointments
  class PayAppointment
    def self.call(appointment, params)
      ActiveRecord::Base.transaction do
        params[:email] = appointment.client.email

        payment_method = Paymongo::PaymentMethods.create(appointment.payment_intent_id, params)
        payment_intent_id = appointment.payment_intent_id
        payment_method_id = payment_method[:id]

        Paymongo::PaymentIntents.attach(payment_intent_id, payment_method_id)

        { status: true, body: nil }
      rescue StandardError => e
        { status: false, body: e.message }
      end
    end
  end
end
