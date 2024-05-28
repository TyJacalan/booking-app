class CreateJoinTableServiceCategory < ActiveRecord::Migration[7.1]
  def change
    create_join_table :services, :categories do |t|
      t.index %i[service_id category_id]
      # t.index [:category_id, :service_id]
    end
  end
end
