class ServicesController < ApplicationController
  rescue_from Pundit::NotAuthorizedError do
    redirect_to root_path, alert: 'Unauthorized access.'
  end

  def index
    @q = Service.ransack(params[:q])
    @services = @q.result(distinct: true)
    authorize @services
  end
end
