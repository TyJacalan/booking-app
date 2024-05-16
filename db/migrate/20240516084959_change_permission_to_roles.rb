class ChangePermissionToRoles < ActiveRecord::Migration[7.1]
  def change
    remove_column :roles, :permission, :string
    add_column :roles, :permission, :json
  end
end
