class Users::BlockedDatesController < ApplicationController
  skip_after_action :verify_authorized

  def index
    user = User.find(params[:user_id])
    blocked_dates = user.blocked_dates.pluck(:date)
    Rails.logger.info "User: #{blocked_dates}"
    render json: { blocked_dates: }
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User not found' }, status: :not_found
  end
end
