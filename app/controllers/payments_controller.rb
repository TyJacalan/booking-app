class PaymentsController < ApplicationController
  skip_after_action :verify_authorized, only: :show
  
  def show
  end

  def create
    @appointment = Appointment.find(params[:appointment_id])
    authorize @appointment

    params[:email] = current_user.email

    payment_method = Paymongo::PaymentMethods.create(@appointment.payment_intent_id, params)
    payment_intent_id = @appointment.payment_intent_id
    payment_method_id = payment_method[:id]
    payment = Paymongo::PaymentIntents.attach(payment_intent_id, payment_method_id)
    Rails.logger.info "Complete: #{payment}"
  end
end