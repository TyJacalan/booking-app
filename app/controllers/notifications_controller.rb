class NotificationsController < ApplicationController
  before_action :set_count_unread

  def index
    @notifications = current_user.notifications.order(:created_at)
    authorize @notifications
  end

  def create
    @notification = Notification.new(notification_params)
    handle_notification_result(@notification.save)
  end

  def update
    @notification = Notification.find(params[:id])
    handle_notification_result(@notification.update(notification_params))
  end

  private

  def handle_notification_result(success)
    respond_to do |format|
      if success
        format.turbo_stream { render 'notifications/turbo/update' }
      else
        format.html { redirect_to internal_error_path }
      end
    end
  end

  def set_count_unread
    @count_unread ||= current_user.notifications.where(read: false).count
  end

  def notification_params
    params.require(:notification).permit(:content, :read)
  end
end
