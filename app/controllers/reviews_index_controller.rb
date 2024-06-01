class ReviewsIndexController < ApplicationController
    after_action :verify_authorized, except: [:recent_10_reviews, :recent_reviews, :most_rated_reviews, :least_rated_reviews]
  
    # GET /services/:service_id/recent_reviews
    # with pagination and streams
    def recent_10_reviews
      @service = Service.find(params[:service_id]) 
      @reviews = @service.reviews.order(created_at: :desc).page(params[:page]).per(10)
  
      respond_to do |format|
        format.js { render json: @reviews }
        format.html { render partial: 'reviews/reviews_list', locals: { service: @service, reviews: @reviews } }
      end
    end
  
    # GET /services/:service_id/recent_reviews
    # with pagination and streams
    def recent_reviews
      @service = Service.find(params[:service_id])
      @reviews = @service.reviews.order(created_at: :desc).page(params[:page]).per(10)
  
      respond_to do |format|
        format.js { render json: @reviews }
        format.html do
          render partial: 'reviews/reviews_list_modal', locals: { service: @service, reviews: @reviews }
        end
      end
    end
  
    # GET /services/:service_id/most_rated_reviews
    # with pagination and streams
    def most_rated_reviews
      @service = Service.find(params[:service_id])
      @reviews = @service.reviews.order(likes_count: :asc).page(params[:page]).per(10)
  
      respond_to do |format|
        format.js { render json: @reviews }
        format.html do
          render partial: 'reviews/reviews_list_modal', locals: { service: @service, reviews: @reviews }
        end
      end
    end
  
    # GET /services/:service_id/least_rated_reviews
    # with pagination and streams
    def least_rated_reviews
      @service = Service.find(params[:service_id])
      @reviews = @service.reviews.order(likes_count: :desc).page(params[:page]).per(10)
  
      respond_to do |format|
        format.js { render json: @reviews }
        format.html do
          render partial: 'reviews/reviews_list_modal', locals: { service: @service, reviews: @reviews }
        end
      end
    end
end
  