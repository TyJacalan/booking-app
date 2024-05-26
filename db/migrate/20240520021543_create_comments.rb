class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments do |t|
      t.text :subject, null: false
      t.references :client, null: false, foreign_key: { to_table: :users}
      t.references :freelancer, null: false, foreign_key: { to_table: :users }
      t.references :review, foreign_key: true
      t.references :appointment, foreign_key: true
      t.timestamps
    end
  end
end