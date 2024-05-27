class PaymentsController < ApplicationController
  skip_after_action :verify_authorized, only: :show

  def show
    @appointment = Appointment.find(params[:id])
  end
end
