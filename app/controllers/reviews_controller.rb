class ReviewsController < ApplicationController
  before_action :set_review, only: %i[show edit update destroy]
  before_action :set_appointment, only: %i[new create]
  after_action :verify_authorized, except: [:index, :show]

  # GET /reviews/:id
  def show
    respond_to do |format|
      format.js { render partial: 'reviews/review_with_comments', locals: { review: @review, comments: @comments } }
      format.html # renders show.html.erb by default
    end
  end

  # GET appointment/:appointment_id/reviews/new
  def new
    @review = @appointment.reviews.new
  end

  # GET /reviews/:id/edit
  def edit
  end

  # POST appointment/:appointment_id/reviews
  def create
    ActiveRecord::Base.transaction do
      @review = @appointment.reviews.new(review_params)
      @review.service_id = @appointment.service.id
      @review.client_id = current_user.id
      @review.freelancer_id = @appointment.freelancer.id

      if @review.save
        respond_to do |format|
          format.html { redirect_to service_review_path(@review.service, @review), notice: 'Review was successfully created.' }
          format.turbo_stream { broadcast_prepend_to(@review.service, :review_modal, target: "review_modal_service_#{review.service.id}", partial: 'reviews/review', locals: { user: current_user, review: @review }) }
        end
      else
        render :new, status: :unprocessable_entity
      end
    end
  rescue ActiveRecord::RecordInvalid
    render :new, status: :unprocessable_entity
  end

  # PATCH/PUT /reviews/:id
  def update
    if @review.update(review_params)
      respond_to do |format|
        format.html { redirect_to service_review_path(@review.service, @review), notice: 'Review was successfully updated.' }
        format.turbo_stream { broadcast_replace_to(@review.service, :review_modal, target: "review_modal_service_#{review.service.id}", partial: 'reviews/review', locals: { user: current_user, review: @review }) }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /reviews/:id
  def destroy
    @review.destroy
    respond_to do |format|
      format.html { redirect_to service_reviews_url(@review.service), notice: 'Review was successfully destroyed.' }
      format.turbo_stream { broadcast_replace_to(@review.service, :review_modal, target: "review_modal_service_#{review.service.id}", html: "<div></div>") }
      #still not working
    end
  end

  private

  def set_appointment
    @appointment = Appointment.find(params[:appointment_id])
  end

  def set_review
    @review = Review.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:subject, :professionalism, :punctuality, :quality, :communication, :value)
  end
end
