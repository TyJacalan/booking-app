class CommentsController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :set_review, only: [:index, :new, :create]
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized, except: [:index, :show, :new, :edit, :destroy, :update, :create]

  # GET /reviews/:review_id/comments
  def index
    @comments = @review.comments
    respond_to do |format|
      format.html { render locals: { review: @review, comments: @comments } }
      format.json { render json: @comments }
    end
  end

  # GET /comments/:id
  def show
    respond_to do |format|
      format.html { render partial: 'comments/comment', locals: { comment: @comment, client: @comment.client, freelancer: @comment.freelancer } }
      format.json { render json: @comment }
    end
  end

  # GET /reviews/:review_id/comments/new
  def new
    @comment = @review.comments.new
    authorize @review
    respond_to do |format|
      format.html { render locals: { comment: @comment, review: @review, client: @review.client, freelancer: @review.freelancer } }
      format.json { render json: @comment }
    end
  end

  # POST /reviews/:review_id/comments
  def create
    authorize @review
    @comment = @review.comments.build(comment_params)
    @comment.appointment = @review.appointment

    # Assign client_id or freelancer_id based on the current user
    if @review.client_id == current_user.id
      @comment.client_id = current_user.id
    elsif @review.freelancer_id == current_user.id
      @comment.freelancer_id = current_user.id
    end

    respond_to do |format|
      if @comment.save
        format.html { render 'new', locals: { review: @review, comment: Comment.new }, notice: 'Comment was successfully created.' }
        format.json { render json: @comment, status: :created }
        Notifications::CreateNotification.create_notification(@comment.freelancer, "#{@comment.client.full_name} created a comment for review #{@comment.review_id}")
        Notifications::CreateNotification.create_notification(@comment.client, "You successfully created a comment for review #{@comment.review_id}")
      else
        if current_user != @review.freelancer_id && current_user != @review.client_id
          format.html { redirect_to service_path(@review.service), status: :unprocessable_entity, notice: "Current user can't create a comment on this review" }
        else
          format.html { redirect_to review_path(@review), status: :unprocessable_entity, notice: "Comment can't be blank" }
          format.json { render json: @comment.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # GET /comments/:id/edit
  def edit
    authorize @comment
    respond_to do |format|
      format.html { render locals: { comment: @comment, client: @comment.client, freelancer: @comment.freelancer } }
    end
  end

  # PATCH/PUT /comments/:id
  def update
    authorize @comment
    if @comment.update(comment_params)
      respond_to do |format|
        format.html { render partial: 'comments/comment', locals: { comment: @comment, client: @comment.client, freelancer: @comment.freelancer }, notice: 'Comment was successfully updated.' }
        format.json { render json: @comment, status: :ok }
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/:id
  def destroy
    authorize @comment
    @comment.destroy
    respond_to do |format|
      format.html { render locals: { comment: @comment } }
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def set_review
    @review = Review.find(params[:review_id])
  end

  def comment_params
    params.require(:comment).permit(:subject)
  end
end
