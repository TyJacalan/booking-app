class AddServiceReferenceToAppointments < ActiveRecord::Migration[7.1]
  def change
    add_reference :appointments, :service, foreign_key: true
  end
end
