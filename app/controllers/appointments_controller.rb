class AppointmentsController < ApplicationController
  before_action :authenticate_user!, except: [:new]
  before_action :set_service, :set_fees, only: %i[new create]
  before_action :set_user, only: %i[index]

  layout 'user', only: [:index]

  def index
    @appointments = Appointment.where(client_id: current_user.id)
                               .or(Appointment
                               .where(freelancer_id: current_user.id))
                               .order(:start)
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

  def update
    @appointment ||= Appointment.find(params[:id])
    authorize @appointment
    handle_appointment_update
  end

  def destroy
    @appointment ||= Appointment.find(params[:id])
    authorize @appointment
    handle_appointment_destroy
  end

  private

  def appointment_params
    params.require(:appointment).permit(:client_id,
                                        :description,
                                        :duration,
                                        :end,
                                        :freelancer_id,
                                        :service_id,
                                        :start,
                                        :status,
                                        :is_completed)
  end

  def handle_appointment_destroy
    respond_to do |format|
      if @appointment.destroy
        flash.now[:notice] =
          "The appointment request for #{@appointment.freelancer.first_name}'s service was successfully deleted"
      else
        flash.now[:alert] = @appointment.errors.full_messages.to_sentence
      end
      format.turbo_stream { render 'appointments/turbo/delete' }
    end
  end

  def handle_appointment_save
    respond_to do |format|
      if @appointment.save
        flash.now[:notice] = 'Appointment request submitted'
        Notifications::CreateNotification.notify_new_appointment(@appointment)
        format.turbo_stream { render 'appointments/turbo/create_success' }
      else
        flash.now[:alert] = @appointment.errors.full_messages.first
        format.turbo_stream { render 'appointments/turbo/create_failure' }
      end
    end
  end

  def handle_appointment_update
    respond_to do |format|
      if @appointment.update(appointment_params)
        Notifications::CreateNotification.notify_updated_appointment(@appointment, current_user)
        flash.now[:notice] =
          "The appointment request for #{@appointment.freelancer.first_name}'s service was successfully updated."
      else
        flash.now[:alert] = @appointment.errors.full_messages.first
        @appointment = Appointment.find(params[:id])
      end
      format.turbo_stream { render 'appointments/turbo/update' }
    end
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

  def set_user
    @user = current_user
  end
end
