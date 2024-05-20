class RemoveRoleBooleansFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :freelancer, :boolean
    remove_column :users, :client, :boolean
  end
end
