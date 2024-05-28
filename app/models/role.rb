# frozen_string_literal: true

class Role < ApplicationRecord
  store_attribute :permissions, :create_services, :boolean, default: false
  store_attribute :permissions, :read_services, :boolean, default: false
  store_attribute :permissions, :update_services, :boolean, default: false
  store_attribute :permissions, :delete_services, :boolean, default: false
  store_attribute :permissions, :create_appointments, :boolean, default: false
  store_attribute :permissions, :read_appointments, :boolean, default: false
  store_attribute :permissions, :update_appointments, :boolean, default: false
  store_attribute :permissions, :delete_appointments, :boolean, default: false
  store_attribute :permissions, :read_notifications, :boolean, default: false
  store_attribute :permissions, :update_notifications, :boolean, default: false
  store_attribute :permissions, :update_roles, :boolean, default: false
end
