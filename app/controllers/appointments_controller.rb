class AppointmentsController < ApplicationController
  rescue_from Pundit::NotAuthorizedError do
    redirect_to root_path, alert: 'Unauthorized access.'
  end

  def index
    @appointments = Appointment.where(client_id: current_user.id)
    authorize @appointments
  end
end
