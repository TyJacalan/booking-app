class ReviewsController < ApplicationController
  before_action :set_service, only: %i[index]
  before_action :set_reviews, only: %i[index]

  def index; end

  private

  def set_service
    @service = Service.find(params[:id])
  end

  def set_reviews
    @reviews = policy_scope(Review).where(service_id: @service.id)
    authorize @reviews
  end
end
