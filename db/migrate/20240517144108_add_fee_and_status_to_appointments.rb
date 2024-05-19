class AddFeeAndStatusToAppointments < ActiveRecord::Migration[7.1]
  def change
    add_column :appointments, :fee, :integer, default: 0
    add_column :appointments, :status, :integer, default: 0
  end
end
