class ReviewsLikesController < ApplicationController
    before_action :set_review
    after_action :verify_authorized, except: [:liked_status, :create, :destroy]

    def liked_status
      @like = @review.likes.find_by(user: current_user)
  
      if @like
        respond_to do |format|
          format.json { render locals: { liked: true, like_id: @like.id } }
          format.html { render partial: 'likes/like_review', locals: { review: @review, likes_count: @review.likes.count } }
        end
      else
        respond_to do |format|
          format.json { render locals: { liked: false } }
          format.html { render partial: 'likes/unlike_review', locals: { review: @review, likes_count: @review.likes.count} }
        end
      end
    end

    def create
      @like = @review.likes.build(user: current_user)

      if @like.save
        respond_to do |format|
          format.json { render locals: {liked: true, like_id: @like.id } }
          format.html { render partial: 'likes/like_review', locals: { review: @review, likes_count: @review.likes.count } }
          Notifications::CreateNotification.create_notification(@review.client, "#{current_user.full_name} liked your review #{@review.id}")
        end
      else
        render json: { error: "Unable to like review" }, status: :unprocessable_entity
      end
    end

    def destroy
      @like = @review.likes.find_by(user: current_user)
      @like.destroy if @like

      respond_to do |format|
        format.json { render locals: { liked: false } }
        format.html { render partial: 'likes/unlike_review', locals: { review: @review, likes_count: @review.likes.count} }
      end
    end

    private

    def set_review
      @review = Review.find(params[:review_id])
    end
end
