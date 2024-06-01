class AddPaymentIdToAppointments < ActiveRecord::Migration[7.1]
  def change
    add_column :appointments, :payment_intent_id, :string
  end
end
