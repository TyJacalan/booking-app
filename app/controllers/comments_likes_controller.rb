class CommentsLikesController < ApplicationController
    before_action :set_comment

    def create
      @like = @comment.likes.new(user: current_user)

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