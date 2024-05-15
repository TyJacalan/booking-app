class AddAttributesToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :freelancer, :boolean
    add_column :users, :client, :boolean
    add_column :users, :biography, :text
    add_column :users, :skills, :json, default: []
    add_column :users, :birthdate, :date
    add_column :users, :address, :string
    add_column :users, :city, :string
    add_column :users, :country, :string
    add_column :users, :mobile, :string
  end
end
