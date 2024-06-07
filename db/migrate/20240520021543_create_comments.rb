class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments do |t|
      t.text :subject, null: false
      t.references :client, foreign_key: { to_table: :users}
      t.references :freelancer, foreign_key: { to_table: :users }
      t.references :review, foreign_key: true, null: false
      t.references :appointment, foreign_key: true, null: false
      t.timestamps
    end
  end
end