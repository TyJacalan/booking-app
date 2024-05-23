class AddReadStatusToNotifications < ActiveRecord::Migration[7.1]
  def change
    add_column :notifications, :read, :boolean, default: 0
  end
end
