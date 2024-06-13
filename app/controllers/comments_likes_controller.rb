class CommentsLikesController < ApplicationController
  before_action :set_comment
  after_action :verify_authorized, except: [:liked_status, :create, :destroy]
  
  def liked_status
    @like = @comment.likes.find_by(user: current_user)

    if @like
      respond_to do |format|
        format.json { render json: { liked: true, like_id: @like.id } }
        format.html { render partial: 'likes/like_comment', locals: { comment: @comment, likes_count: @comment.likes.count } }
      end
    else
      respond_to do |format|
        format.json { render json: { liked: false } }
        format.html { render partial: 'likes/unlike_comment', locals: { comment: @comment, likes_count: @comment.likes.count } }
      end
    end
  end

  def create
    @like = @comment.likes.build(user: current_user)

    if @like.save
      respond_to do |format|
        format.json { render json: { liked: true, like_id: @like.id } }
        format.html { render partial: 'likes/like_comment', locals: { comment: @comment, likes_count: @comment.likes.count } }
        Notifications::CreateNotification.create_notification(@comment.freelancer || @comment.client, "#{current_user.full_name} liked your comment #{@comment.id}")
      end
    else
      render json: { error: "Unable to like comment" }, status: :unprocessable_entity
    end
  end

  def destroy
    @like = @comment.likes.find_by(user: current_user)
    
    if @like
      @like.destroy
    end

    respond_to do |format|
      format.json { render json: { liked: false } }
      format.html { render partial: 'likes/unlike_comment', locals: { comment: @comment, likes_count: @comment.likes.count } }
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:comment_id])
  end
end
