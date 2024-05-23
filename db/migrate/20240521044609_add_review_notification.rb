class AddReviewNotification < ActiveRecord::Migration[7.1]
  def change
    add_column :appointments, :review_notification_sent, :boolean
    add_column :appointments, :is_completed, :boolean
  end
end
