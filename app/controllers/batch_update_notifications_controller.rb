class BatchUpdateNotificationsController < ApplicationController
  skip_after_action :verify_authorized
  before_action :fetch_notifications

  def update
    @read_status = params[:button] == 'mark_read'

    if @notifications.present? && @notifications.update_all(read: @read_status)
      handle_response
    else
      handle_response('No notifications selected')
    end
  end

  private

  def fetch_notifications
    notification_ids = params[:notification_ids]
    @notifications = current_user.notifications.where(id: notification_ids).where.not(read: @read_status)
  end

  def handle_response(alert = nil)
    @count_unread = @notifications.where(read: false).count
    respond_to do |format|
      flash.now[:alert] = alert if alert.present?
      format.turbo_stream
    end
  end
end
