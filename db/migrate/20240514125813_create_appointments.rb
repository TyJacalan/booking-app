class CreateAppointments < ActiveRecord::Migration[7.1]
  def change
    create_table :appointments do |t|
      t.date :date, null: false
      t.text :description, null: false
      t.references :client, null: false, foreign_key: { to_table: :users }
      t.references :freelancer, null: false, foreign_key: { to_table: :users }
      
      t.timestamps
    end
  end
end