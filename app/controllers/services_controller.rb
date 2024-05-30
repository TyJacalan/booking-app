class ServicesController < ApplicationController
  before_action :set_service, only: %i[show]
  before_action :set_categories, only: %i[new show]
  before_action :set_session_params, only: %i[create]
  before_action :set_session_form, only: [:new]
  after_action :verify_authorized, except: %i[index new show]

  def index
    # ULTIMATE SUPREME SEARCH LOGIC QUERY
    @q = Service.ransack(params[:q])

    if params[:q].present? && params[:q][:combined_search].present?
      search_query = params[:q][:combined_search]
      terms = search_query.split

      service_ids = Service.joins(:user, :categories).where(
        terms.map do
          "concat_ws(' ', users.full_name, services.title, categories.title, users.city) ILIKE ?"
        end.join(' AND '), *terms.map { |term| "%#{term}%" }
      ).pluck(:id).uniq

      @services = Service.where(id: service_ids).includes(:user, :categories)
    else
      @services = @q.result.includes(:user, :categories)
    end

    authorize @services
  end

  def create
    @service = Service.new(service_params)
    @service.user = current_user
    authorize @service

    if @service.save
      clear_session_params
      redirect_to @service, notice: 'Service was successfully created.'
    else
      render :new
    end
  end

  def show
    @service = set_service
    authorize @service
  end

  private

  def set_service
    @set_service ||= Service.find(params[:id])
  end

  def service_params
    params.require(:service).permit(:title, :description, :price, category_ids: [])
  end

  def set_session_form
    session[:form] = 'categories'
  end

  def set_session_params
    category_ids = session[:selected_categories].map { |category| category['id'] } || []

    session_params = {
      title: session[:title],
      description: session[:description],
      price: session[:price],
      category_ids:
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

  def set_categories
    @categories = Category.all
  end
end
