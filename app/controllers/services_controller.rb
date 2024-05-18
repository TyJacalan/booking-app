class ServicesController < ApplicationController
  rescue_from Pundit::NotAuthorizedError do
    redirect_to root_path, alert: 'Unauthorized access.'
  end

  def index
    @services = Service.all
    authorize @services
  end

  def new
    @service = Service.new
    authorize @service
  end
end
