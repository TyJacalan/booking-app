class ReviewsController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :set_review, only: [:show, :edit, :update, :destroy]
  before_action :set_appointment, only: [:new, :create]
  after_action :verify_authorized, except: [:show, :new, :edit, :destroy, :update, :create]

  # GET /reviews/:id
  def show
    respond_to do |format|
      format.html { render locals: { review: @review, comments: @review.comments, service: @review.service } }
    end
  end

  # GET /appointments/:appointment_id/reviews/new
  def new
    @review = @appointment.reviews.new
    respond_to do |format|
      format.html { render locals: { review: @review, appointment: @appointment, service: @review.service } }
    end
  end

  # GET /reviews/:id/edit
  def edit
    respond_to do |format|
      format.html { render locals: { review: @review, appointment: @review.appointment, service: @review.service} }
    end
  end

  # POST /appointments/:appointment_id/reviews
  def create
    ActiveRecord::Base.transaction do
      @review = @appointment.reviews.new(review_params)
      @review.service_id = @appointment.service.id
      @review.client_id = current_user.id
      @review.freelancer_id = @appointment.freelancer.id

      if @review.save
        respond_to do |format|
          format.html { redirect_to service_review_path(@review.service, @review), notice: 'Review was successfully created.' }
          Notifications::CreateNotification.create_notification(@review.freelancer, "#{@review.client.full_name} created a review for service #{@review.service.title}")
          Notifications::CreateNotification.create_notification(@review.client, "You successfully created a review for service #{@review.service.title}")
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
        format.html { redirect_to service_path(@review.service), notice: 'Review was successfully updated.' }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /reviews/:id
  def destroy
    @review.destroy
    #respond_to do |format|
      #format.html { redirect_to service_reviews_url(@review.service), notice: 'Review was successfully destroyed.' }
      #format.turbo_stream { broadcast_replace_to(@review.service, :review_modal, target: dom_id(@review, :service_modal), html: "<div class='hidden'></div>") }
      #format.turbo_stream { broadcast_replace_to(@review.service, :review, target: dom_id(@review, :service), html: "<div class='hidden'></div>") }
    #end
  end

  private

  def set_appointment
    @appointment = Appointment.find(params[:appointment_id])
  end

  def set_review
    @review = Review.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:professionalism, :punctuality, :quality, :communication, :value, :overall_rating, :subject)
  end
end
