class AlertsController < ApplicationController
  def index
    @notifications = current_user.notifications.order(:created_at).limit(5)
    @count_unread = current_user.notifications.where(read: false).count
    authorize @notifications
  end
end
