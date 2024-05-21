class AppointmentsController < ApplicationController
  before_action :set_appointment, only: %i[destroy]
  before_action :set_service, :set_fees, only: %i[new create]

  def index
    @appointments = Appointment.where(client_id: current_user.id).or(Appointment.where(freelancer_id: current_user.id))
    authorize @appointments
  end

  def new
    @appointment = @service.appointments.new
    authorize :appointment, :new?
  end

  def create
    @appointment = Appointment.new(appointment_params)
    authorize @appointment

    handle_appointment_save
  end

  def destroy
    authorize @appointment
    handle_appointment_destroy
  end

  private

  def set_appointment
    @appointment ||= Appointment.find(params[:id])
  end

  def set_service
    service_id ||= params[:id] || params.dig(:appointment, :service_id)
    @service = Service.find(service_id)
  end

  def set_fees
    @price ||= @service.price
    @service_fee ||= @price * 0.025
    @total_fee ||= @price + @service_fee
  end

  def handle_appointment_save
    respond_to do |format|
      if @appointment.save
        flash.now[:notice] = 'Appointment request submitted'
        format.turbo_stream { render 'appointments/create_success' }
      else
        flash.now[:alert] = @appointment.errors.full_messages.first
        format.turbo_stream { render 'appointments/create_failure' }
      end
    end
  end

  def handle_appointment_destroy
    respond_to do |format|
      if @appointment.destroy
        flash.now[:notice] = "The appointment request for #{@appointment.freelancer.first_name}'s service was successfully deleted"
      else
        flash.now[:alert] = @appointment.errors.full_messages.to_sentence
      end
      format.turbo_stream { render 'appointments/delete', locals: { id: @appointment.id } }
    end
  end

  def appointment_params
    params.require(:appointment).permit(:description, :start, :end, :duration, :service_id, :client_id, :freelancer_id)
  end
end
