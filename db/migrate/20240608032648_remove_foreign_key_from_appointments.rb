class RemoveForeignKeyFromAppointments < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :appointments, :services
  end
end
