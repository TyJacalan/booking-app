class CommentsController < ApplicationController
    before_action :set_comment
    before_action :set_review
    
    def new
    end

    def create
        @comment = @review.comments.build(comment_params)
    
        if @comment.save
          CommentsChannel.broadcast_to(@review, @comment)
          render partial: 'comments/comment', locals: { comment: @comment }
        else
          # Handle error
        end
    end

    def destroy 
    end

    private

    def set_comment
    end

    def set_review
        @review = Review.find(params[:review_id])
    end

    def comment_params
        params.require(:comment).permit(:subject)
    end   
end

