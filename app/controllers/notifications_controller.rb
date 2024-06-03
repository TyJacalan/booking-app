class NotificationsController < ApplicationController
  def index
    @notifications = current_user.notifications.order(:created_at).page(params[:page]).per(20)
    authorize @notifications
  end

  def update
    @notification = Notification.find(params[:id])
    authorize @notification
    handle_notification_result(@notification.update(notification_params))
  end

  private

  def handle_notification_result(success)
    respond_to do |format|
      if success
        @count_unread = current_user.notifications.where(read: false).count
        format.turbo_stream
      else
        format.html { redirect_to internal_error_path }
      end
    end
  end

  def notification_params
    params.require(:notification).permit(:content, :read)
  end
end
