class ServicesController < ApplicationController
  before_action :set_service, only: %i[show]
  after_action :verify_authorized, except: %i[index show]

  def index
    @q = Service.ransack(params[:q])
    if params[:q].present? && params[:q][:combined_search].present?
      search_query = params[:q][:combined_search]
      @services = Service.joins(:user).where("concat_ws(' ', users.full_name, services.title, users.city) ILIKE ?",
                                             "%#{search_query}%")
    else
      @services = @q.result.includes(:user)
    end

    authorize @services
  end

  def create
    @service = Service.new(service_params)
    @service.user = current_user
    authorize @service

    if @service.save
      redirect_to @service, notice: 'Service was successfully created.'
    else
      render :new
    end
  end

  def show
    @service = @set_service
    authorize @service
  end

  private

  def set_service
    @set_service ||= Service.find(params[:id])
  end

  def service_params
    params.require(:service).permit(:title, :description, :price, :categories)
  end

  def service_params
    params.require(:service).permit(:title, :description, :price, :categories)
  end
end
