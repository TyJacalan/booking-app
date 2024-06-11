class ServicesController < ApplicationController
  before_action :authorize_service
  before_action :set_service, only: %i[show edit update destroy]
  before_action :set_categories, only: %i[new edit create update show]
  after_action :verify_authorized, except: %i[index new show]

  def index
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

      @services = Service.where(id: service_ids).includes(:user, :categories, :overall_service_rating)
    else
      @services = @q.result.includes(:user, :categories, :overall_service_rating)
    end

    @services = @services.page(params[:page]).per(6)
  end

  def create
    modified_params = transform_category_ids(service_params)
    @service = current_user.services.build(modified_params)

    if @service.save
      redirect_to @service, notice: 'Service was successfully created.'
    else
      flash.now[:alert] = 'Failed to publish service. Make sure you provided all details.'
      render :new
    end
  end

  def show; end

  def new
    @service = Service.new
  end

  def edit; end

  def update
    modified_params = transform_category_ids(service_params)
    if @service.update(modified_params)
      redirect_to @service, notice: 'Service was successfully updated.'
    else
      flash.now[:alert] = 'Failed to update service. Make sure you provided all details.'
      render :edit
    end
  end

  def destroy
    @service.destroy
    redirect_to services_path, notice: 'Service was successfully deleted.'
  end

  private

  def authorize_service
    authorize Service
  end

  def set_service
    @service = Service.find(params[:id])
  end

  def service_params
    params.require(:service).permit(:title, :description, :price, category_ids: [])
  end

  def set_categories
    @categories = Category.all
  end

  def transform_category_ids(params)
    if params[:category_ids]
      params[:category_ids] = params[:category_ids].flat_map { |s| s.split(',') }.map(&:to_i)
    end
    params
  end
end
