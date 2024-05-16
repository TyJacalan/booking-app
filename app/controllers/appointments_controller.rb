class AppointmentsController < ApplicationController
  rescue_from Pundit::NotAuthorizedError do
    redirect_to root_path, alert: 'Unauthorized access.'
  end

  def index
    @appointments = Appointment.all
    authorize @appointments
  end
end
