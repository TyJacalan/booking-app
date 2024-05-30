class ChangeReviewsTable < ActiveRecord::Migration[7.1]
  def change
    remove_column :reviews, :rating

    add_column :reviews, :professionalism, :integer, null: false
    add_column :reviews, :punctuality, :integer, null: false
    add_column :reviews, :quality, :integer, null: false
    add_column :reviews, :communication, :integer, null: false
    add_column :reviews, :value, :integer, null: false
    add_column :reviews, :overall_rating, :integer, null: false
    add_reference :reviews, :appointment, foreign_key: true, null: false
  end
end
