class CreateOverallServiceRatings < ActiveRecord::Migration[7.1]
  def change
    create_table :overall_service_ratings do |t|
      t.references :service, null: false, foreign_key: true
      t.integer :cleanliness, default: 0
      t.integer :accuracy, default: 0
      t.integer :checkin, default: 0
      t.integer :communication, default: 0
      t.integer :location, default: 0
      t.integer :value, default: 0
      t.integer :overall_rating, default: 0
      t.integer :count, default: 0
      t.timestamps
    end
  end
end
