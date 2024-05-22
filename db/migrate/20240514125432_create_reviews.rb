class CreateReviews < ActiveRecord::Migration[7.1]
  def change
    create_table :reviews do |t|
      t.integer :professionalism, null: false
      t.integer :punctuality, null: false
      t.integer :quality, null: false
      t.integer :communication, null: false
      t.integer :value, null: false
      t.integer :overall_rating, null: false
      t.text :subject
      t.references :client, null: false, foreign_key: { to_table: :users }
      t.references :freelancer, null: false, foreign_key: { to_table: :users }
      t.references :service, foreign_key: true

      t.timestamps
    end
  end
end