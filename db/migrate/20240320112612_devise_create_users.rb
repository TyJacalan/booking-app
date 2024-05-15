# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :first_name,          null: false, default: ''
      t.string :last_name,           default: ''
      t.string :email,              null: false, default: ''
      t.string :encrypted_password, null: false, default: ''
      t.string :full_name
      t.string :uid
      t.string :avatar_url
      t.string :provider

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
  end
end
