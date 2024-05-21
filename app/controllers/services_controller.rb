class ServicesController < ApplicationController
  before_action :set_service, only: %i[show]
  rescue_from Pundit::NotAuthorizedError do
    redirect_to root_path, alert: 'Unauthorized access.'
  end

  def index
    @q = Service.ransack(params[:q])

    if params[:q].present? && params[:q][:combined_search].present?
      search_query = params[:q][:combined_search]
      @services = Service.joins(:user).where("concat_ws(' ', services.title, users.city) ILIKE ?", "%#{search_query}%")
    else
      @services = @q.result.includes(:user)
    end

    authorize @services
  end

  def show
    @service = @set_service
  end

  private

  def set_service
    @set_service ||= Service.find(params[:id])
    authorize @set_service
  end
end
