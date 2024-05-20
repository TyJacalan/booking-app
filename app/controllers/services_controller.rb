class ServicesController < ApplicationController
  before_action :set_service, only: %i[show]
  after_action :verify_authorized, except: %i[index show]

  rescue_from Pundit::NotAuthorizedError do |exception|
    Rails.logger.error("Authorization failed: #{exception.message}")
    redirect_to root_path, alert: 'Unauthorized access: Services'
  end

  def index
    # @q = Service.ransack(params[:q])
    # @services = @q.result(distinct: true)
    @services = Service.all
    authorize @services
  end

  def new
    @service = Service.new
    authorize @service
  end

  def create
    @service = Service.new(service_params)
    @service.user = current_user
    authorize @service

    if @service.save
      redirect_to @service, notice: "Service was successfully created."
    else
      render :new
    end
  end

  def show
    @service = @set_service
    authorize @service
    @appointment = Appointment.new
    authorize @appointment
  end

  private

  def set_service
    @set_service ||= Service.find(params[:id])
    authorize @set_service
  end

  def service_params
    params.require(:service).permit(:title, :description, :price, :categories)
  end
end
