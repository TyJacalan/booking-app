class ServicesController < ApplicationController
  before_action :authorize_service
  before_action :set_service, only: %i[show edit update destroy]
  before_action :set_categories, only: %i[new edit update show]
  before_action :set_session_params, only: %i[create update]
  before_action :set_session_form, only: %i[new edit]
  after_action :verify_authorized, except: %i[index new show]

  def index
    # ULTIMATE SUPREME SEARCH LOGIC QUERY
    @q = Service.ransack(params[:q])

    if params[:q].present?
      search_params = params[:q].select { |_key, value| value.present? }
      terms = search_params.values

      conditions = []
      search_params.each_key do |key, _value|
        case key
        when 'user_full_name_cont'
          conditions << 'users.full_name ILIKE ?'
        when 'title_cont'
          conditions << 'services.title ILIKE ?'
        when 'categories_title_cont'
          conditions << 'categories.title ILIKE ?'
        when 'user_city_cont'
          conditions << 'users.city ILIKE ?'
        end
      end

      service_ids = Service.joins(:user, :categories).where(
        conditions.join(' AND '), *terms.map { |term| "%#{term}%" }
      ).pluck(:id).uniq

      @services = Service.where(id: service_ids).includes(:user, :categories)
    else
      @services = @q.result.includes(:user, :categories)
    end

    @services = @services.page(params[:page]).per(12)
  end

  def create
    @service = current_user.services.build(service_params)
    if @service.save
      clear_session_params
      redirect_to @service, notice: 'Service was successfully created.'
    else
      render :new
    end
  end

  def show; end

  def edit
    assign_service_to_sessions
  end

  def update
    if @service.update(service_params)
      redirect_to @service, notice: 'Service was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @service.destroy
    redirect_to services_path, notice: 'Service was successfully deleted.'
  end

  private

  def set_service
    @service = Service.find(params[:id])
  end

  def service_params
    params.require(:service).permit(:title, :description, :price, category_ids: [])
  end

  def set_session_form
    session[:form] = 'categories'
  end

  def set_session_params
    session_params = {
      title: session[:title],
      description: session[:description],
      price: session[:price],
      category_ids: session[:selected_categories].map { |category| category['id'] } || []
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

  def assign_service_to_sessions
    session[:service_id] = @service.id
    session[:title] = @service.title
    session[:description] = @service.description
    session[:price] = @service.price
    session[:selected_categories] = @service.categories
    session[:action] = 'edit'
  end

  def authorize_service
    authorize Service
  end
end
