class ReviewsController < ApplicationController
  before_action :set_service, only: %i[index new create]
  before_action :set_review, only: %i[show edit update destroy]
  before_action :set_reviews, only: %i[index]

  # GET /services/:service_id/reviews
  def index
    respond_to do |format|
      format.js { render partial: 'reviews/reviews_list', locals: { reviews: @reviews } }
      format.html # renders index.html.erb by default
      #turbo stream
    end
  end

  # GET /reviews/:id
  def show
    @comments = @review.comments

    respond_to do |format|
      format.js { render partial: 'reviews/review_with_comments', locals: { review: @review, comments: @comments } }
      format.html # renders show.html.erb by default
    end
  end

  # GET /services/:service_id/appointment/:appointment_id/reviews/new
  def new
    @review = @service.reviews.new
  end

  # GET /reviews/:id/edit
  def edit
  end

  # POST /services/:service_id/appointment/:appointment_id/reviews
  # edit
  def create
    ActiveRecord::Base.transaction do
      @review = @appoitment.build_reviews(review_params)
      @review.appointment_id = params[:appointment_id]
      @review.client_id = current_user.id
  
      if @review.save!
        redirect_to service_review_path(@service, @review), notice: 'Review was successfully created.'
        #turbo stream
      else
        raise ActiveRecord::Rollback
      end
    end
  rescue ActiveRecord::RecordInvalid
    render :new
  end
  

  # PATCH/PUT /reviews/:id
  def update
    if @review.update(review_params)
      redirect_to service_review_path(@service, @review), notice: 'Review was successfully updated.'
      #turbo stream
    else
      render :edit
    end
  end

  # DELETE /reviews/:id
  def destroy
    @review.destroy
    redirect_to service_reviews_url(@service), notice: 'Review was successfully destroyed.'
  end

  private

  def set_service
    @service = Service.find(params[:service_id])
  end

  def set_review
    @review = Review.find(params[:id])
  end

  def set_reviews
    @reviews = policy_scope(Review).where(service_id: @service.id)
    authorize @reviews
  end

  def review_params
    params.require(:review).permit(:subject, :professionalism, :punctuality, :quality, :communication, :value)
  end
end
