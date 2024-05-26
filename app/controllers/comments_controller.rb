class CommentsController < ApplicationController
  before_action :set_review, onyl: [:new, :create]
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

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
      format.html # renders show.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /reviews/:review_id/comments/new
  def new
    @comment = @review.comments.new
  end

  # POST /reviews/:review_id/comments
  def create
    @comment = @review.comments.build(comment_params)
    @comment.user = current_user # assuming a user is creating the comment

    if @comment.save
      CommentsChannel.broadcast_to(@review, @comment)
      respond_to do |format|
        format.html { redirect_to review_path(@review), notice: 'Comment was successfully created.' }
        format.json { render json: @comment, status: :created }
        format.js { render partial: 'comments/comment', locals: { comment: @comment } }
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
        format.js { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /comments/:id/edit
  def edit
  end

  # PATCH/PUT /comments/:id
  def update
    if @comment.update(comment_params)
      respond_to do |format|
        format.html { redirect_to review_path(@review), notice: 'Comment was successfully updated.' }
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
    @comment = @review.comments.find(params[:id])
  end

  def set_review
    @review = Review.find(params[:review_id])
  end

  def comment_params
    params.require(:comment).permit(:subject, :content)
  end
end
