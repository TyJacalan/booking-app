class AddUserIdToCategories < ActiveRecord::Migration[7.1]
  def change
    add_reference :categories, :user, null: false, foreign_key: true
  end
end
