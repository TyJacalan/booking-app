class ServicesController < ApplicationController
  before_action :set_service, only: %i[show]
  rescue_from Pundit::NotAuthorizedError do
    redirect_to root_path, alert: 'Unauthorized access.'
  end

  def index
    @q = Service.ransack(params[:q])
    @services = @q.result(distinct: true)
    authorize @services
  end

  def new
    @service = Service.new
    authorize @service
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
