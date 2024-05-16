# frozen_string_literal: true

class Role < ApplicationRecord
  # Define accessors for the JSON attributes
  store_accessor :permissions, :create_services, :read_services, :update_services, :delete_services
  store_accessor :permissions, :create_appointments, :read_appointments, :update_appointments, :delete_appointments

  # Ensure default values are set
  after_initialize :set_default_permissions, if: :new_record?

  private

  def set_default_permissions
    self.permissions ||= {
      create_services: false,
      read_services: false,
      update_services: false,
      delete_services: false,
      create_appointments: false,
      read_appointments: false,
      update_appointments: false,
      delete_appointments: false
    }
  end
end
