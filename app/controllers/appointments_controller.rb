class AppointmentsController < ApplicationController
  before_action :authenticate_user!, except: [:new]
  before_action :set_appointment, only: %i[edit update destroy]
  before_action :set_service, only: [:new]

  def index
    @appointments = fetch_appointments
    @statuses = Appointment.statuses.to_a
  end

  def new
    @appointment = @service.appointments.new
    authorize @appointment
  end

  def create
    @appointment = Appointment.new(appointment_params)
    authorize @appointment

    if Appointments::CreateAppointment.call(@appointment)
      respond_to_success(payment_path(@appointment.id))
    else
      respond_to_failure('appointments/turbo/create_failure', @appointment.errors.full_messages.first)
    end
  end

  def edit; end

  def update
    if Appointments::UpdateAppointment.call(@appointment, current_user, appointment_params)
      respond_to_success_with_notice('appointments/turbo/update', "The appointment request for #{@appointment.freelancer.first_name}'s service was successfully updated.")
    else
      respond_to_failure('appointments/turbo/update', @appointment.errors.full_messages.first)
    end
  end

  def destroy
    if @appointment.destroy
      respond_to_success_with_notice('appointments/turbo/delete', "The appointment request for #{@appointment.freelancer.first_name}'s service was successfully deleted")
    else
      respond_to_failure('appointments/turbo/delete', @appointment.errors.full_messages.to_sentence)
    end
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

  def fetch_appointments
    appointments = Appointments::FetchAppointments.call(current_user)
    authorize appointments

    @q = Appointment.ransack(params[:q])
    appointments = @q.result(distinct: true).where(id: appointments.pluck(:id))

    @appointments = Kaminari.paginate_array(appointments).page(params[:page]).per(5)
  end

  def set_appointment
    @appointment = Appointment.find(params[:id])
    authorize @appointment
  end

  def set_service
    @service = Service.find(params[:service_id])
  end

  def respond_to_success(path)
    respond_to do |format|
      format.turbo_stream { redirect_to path }
    end
  end

  def respond_to_success_with_notice(template, notice)
    @status = true
    flash.now[:notice] = notice
    respond_to do |format|
      format.turbo_stream { render template }
    end
  end

  def respond_to_failure(template, alert)
    @status = false
    flash.now[:alert] = alert
    respond_to do |format|
      format.turbo_stream { render template }
    end
  end
end
