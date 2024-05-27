class ServicesController < ApplicationController
  before_action :set_service, only: %i[show edit update destroy]
  before_action :set_session_params, only: %i[new create]
  before_action :set_session_form, only: %i[new]
  after_action :verify_authorized, except: %i[index new show]

  def index
    @q = Service.ransack(params[:q])
    @services = if params[:q].present? && params[:q][:combined_search].present?
                  search_combined(params[:q][:combined_search])
                else
                  @q.result.includes(:user)
                end

    authorize @services
  end

  def new
    @service = Service.new
  end

  def create
    @service = current_user.services.build(service_params)
    authorize @service

    if @service.save
      clear_session_params
      redirect_to @service, notice: 'Service was successfully created.'
    else
      render :new
    end
  end

  def show
    authorize @service
  end

  def edit
    authorize @service
  end

  def update
    authorize @service

    if @service.update(service_params)
      redirect_to @service, notice: 'Service was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authorize @service
    @service.destroy
    redirect_to services_path, notice: 'Service was successfully deleted.'
  end

  private

  def set_service
    @service = Service.find(params[:id])
  end

  def service_params
    params.require(:service).permit(:title, :description, :price, categories: [])
  end

  def set_session_form
    session[:form] = 'categories'
  end

  def set_session_params
    session_params = {
      title: session[:title],
      description: session[:description],
      price: session[:price],
      categories: session[:selected_categories]
    }
    params[:service] ||= {}
    params[:service].merge!(session_params)
  end

  def clear_session_params
    session.delete(:title)
    session.delete(:description)
    session.delete(:price)
    session.delete(:selected_categories)
  end

  def search_combined(query)
    Service.joins(:user).where(
      "concat_ws(' ', users.full_name, services.title, users.city) ILIKE ?", "%#{query}%"
    )
  end
end
