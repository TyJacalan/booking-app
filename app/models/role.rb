class Role < ApplicationRecord
  store :permissions, accessors: [
    :create_services,
    :read_services,
    :update_services,
    :delete_services,
    :create_appointments,
    :read_appointments,
    :update_appointments,
    :delete_appointments
  ], coder: JSON
end
