class ChangeAppointmentsDateToStartAndEndDate < ActiveRecord::Migration[7.1]
  def change
    remove_column :appointments, :date, :date
    add_column :appointments, :start, :datetime
    add_column :appointments, :end, :datetime
  end
end
