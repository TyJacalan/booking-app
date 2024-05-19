class ServicesController < ApplicationController
  before_action :set_service, only: %i[show]
  rescue_from Pundit::NotAuthorizedError do
    redirect_to root_path, alert: 'Unauthorized access.'
  end

  def index
    @services = Service.all
    authorize @services
  end

  def show
    @service = @set_service
  end

  private

  def set_service
    @set_service ||= Service.find(params[:id])
  end
end
