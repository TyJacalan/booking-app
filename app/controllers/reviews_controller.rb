class ReviewsController < ApplicationController
  before_action :set_review only %i[]
  before_action :set_service only %i[index, new, create]
  #/service/service_id/
  def index
    @service = Service.find(params[:service_id])
    @reviews = @service.reviews

    respond_to do |format|
      format.js { render partial: 'reviews/reviews_list', locals: { reviews: @reviews } }
    end
  end

  def show
    @review = Review.find(params[:id])
    @comments = @review.comments

    respond_to do |format|
      format.js { render partial: 'reviews/review_with_comments', locals: { review: @review, comments: @comments } }
    end
  end

  def new
  end

  def create 
  end

  def destroy 
  end

  private

  def set_review
    @service = Service.find(params[:service_id])
  end

  def review_params
    params.require(:review).permit(:subject, :professionalism, :punctuality, :quality, :communication, :value,)
  end
end
