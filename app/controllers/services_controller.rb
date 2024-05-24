class ServicesController < ApplicationController
  before_action :set_service, only: %i[show]
  before_action :set_session_params, only: %i[new create]
  before_action :set_session_form, only: [:new]
  after_action :verify_authorized, except: %i[index new show]

  def index
    @q = Service.ransack(params[:q])
    @services = @q.result(distinct: true)
    @services = Service.all
    authorize @services
  end

  def new
    @service = Service.new
  end

  def create
    @service = Service.new(service_params)
    @service.user = current_user
    authorize @service

    if @service.save
      clear_session_params
      redirect_to @service, notice: "Service was successfully created."
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
end
