class AddReviewNotification < ActiveRecord::Migration[7.1]
  def change
    add_column :appointments, :review_notification_sent, :boolean, default: false, null: false
    #default: false, null: false
    add_column :appointments, :is_completed, :boolean, default: false, null: false
  end
end
