class AddDurationToAppointments < ActiveRecord::Migration[7.1]
  def change
    add_column :appointments, :duration, :integer
  end
end
