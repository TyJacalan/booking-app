class CommentsLikesController < ApplicationController
  before_action :set_comment

  def liked_status
    @like = @comment.likes.find_by(user: current_user)

    if @like
      render json: { liked: true, like_id: @like.id }
    else
      render json: { liked: false }
    end
  end
  
  def create
    @like = @comment.likes.build(user: current_user)

    if @like.save
      render json: { likes_count: @comment.likes.count, liked: true }
    else
      render json: { error: "Unable to like comment" }, status: :unprocessable_entity
    end
  end

  def destroy
    @like = @comment.likes.find_by(user: current_user)
    @like.destroy if @like

    render json: { likes_count: @comment.likes.count, liked: false }
  end

  private

  def set_comment
    @comment = Comment.find(params[:comment_id])
  end
end