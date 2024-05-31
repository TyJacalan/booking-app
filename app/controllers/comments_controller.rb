class CommentsController < ApplicationController
  before_action :set_review, only: [:new, :create]
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized, except: [:show, :new, :edit, :destroy, :update, :create]

  # GET /reviews/:review_id/comments
  def index
    @comments = @review.comments
    respond_to do |format|
      format.html # renders index.html.erb
      format.json { render json: @comments }
    end
  end

  # GET /comments/:id
  def show
    respond_to do |format|
      format.html { render partial: 'comments/comment', locals: { comment: @comment, client: @comment.client, freelancer: @comment.freelancer }}
      format.json { render json: @comment }
    end
  end

  # GET /reviews/:review_id/comments/new
  def new
    @comment = @review.comments.new
    respond_to do |format|
      format.html { render locals: { comment: @comment, review: @review, client: @review.client, freelancer: @review.freelancer } }
      format.json { render json: @comment }
    end
  end

  # POST /reviews/:review_id/comments
  def create
    @review = Review.find(params[:review_id])
    @comment = @review.comments.build(comment_params)
    @comment.appointment_id = @review.appointment_id

    # Assign client_id or freelancer_id based on current user
    if @review.client_id == current_user.id
      @comment.client_id = current_user.id
    elsif @review.freelancer_id == current_user.id
      @comment.freelancer_id = current_user.id
    end

    if @comment.save
      CommentsChannel.broadcast_to(@review, @comment)
      respond_to do |format|
        format.html { redirect_to review_path(@review), notice: 'Comment was successfully created.' }
        format.json { render json: @comment, status: :created }
      end
    else
      respond_to do |format|
        format.html { render :new, locals: { comment: @comment, review: @review, client: @review.client, freelancer: @review.freelancer }}
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /comments/:id/edit
  def edit
    respond_to do |format|
      format.html { render locals: { comment: @comment, client: @comment.client, freelancer: @comment.freelancer}}
    end
  end

  # PATCH/PUT /comments/:id
  def update
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
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to review_path(@review), notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
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
