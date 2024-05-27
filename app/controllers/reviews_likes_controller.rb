class ReviewsLikesController < ApplicationController
    before_action :set_review

    def create
      @like = @review.likes.build(user: current_user)

      if @like.save
        render json: { likes_count: @review.likes.count, liked: true }
      else
        render json: { error: "Unable to like review" }, status: :unprocessable_entity
      end
    end

    def destroy
      @like = @review.likes.find_by(user: current_user)
      @like.destroy if @like

      render json: { likes_count: @review.likes.count, liked: false }
    end

    private

    def set_review
      @review = Review.find(params[:review_id])
    end
end
