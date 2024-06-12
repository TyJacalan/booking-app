class AddReviewsCountToServices < ActiveRecord::Migration[7.1]
  def change
    add_column :services, :reviews_count, :integer, default: 0
  end
end
