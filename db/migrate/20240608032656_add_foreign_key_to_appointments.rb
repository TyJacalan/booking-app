class AddForeignKeyToAppointments < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :appointments, :services, on_delete: :cascade
  end
end
