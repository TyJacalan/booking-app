class PaymentsController < ApplicationController
  skip_after_action :verify_authorized, only: :show

  def show; end

  def create
    @appointment = Appointment.find(params[:appointment_id])
    authorize @appointment

    response = Appointments::PayAppointment.call(@appointment, params)

    if response[:status]
      flash[:notice] = 'Payment Successful'
      redirect_to response[:body], allow_other_host: true
    else
      flash[:alert] = "#{response[:body].capitalize}"
      redirect_to payments_path(@appointment.id)
    end
  end
end
