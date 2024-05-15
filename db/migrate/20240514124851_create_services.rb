class CreateServices < ActiveRecord::Migration[7.1]
  def change
    create_table :services do |t|
      t.string :title, null: false
      t.text :description
      t.integer :price, null: false
      t.json :categories, default: []
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
