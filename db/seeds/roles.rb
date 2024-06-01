# frozen_string_literal: true

Role.find_or_create_by!(name: 'freelancer') do |r|
  r.permissions = {
    create_appointments: false,
    create_services: true,
    create_blocked_dates: true,
    delete_appointments: false,
    delete_blocked_dates: true,
    delete_services: true,
    read_appointments: true,
    read_blocked_dates: true,
    read_notifications: true,
    read_services: true,
    update_appointments: true,
    update_notifications: true,
    update_roles: true,
    update_services: true
  }
end

Role.find_or_create_by!(name: 'client') do |r|
  r.permissions = {
    create_appointments: true,
    create_services: false,
    create_blocked_dates: false,
    delete_appointments: true,
    delete_blocked_dates: false,
    delete_services: false,
    read_appointments: true,
    read_blocked_dates: true,
    read_notifications: true,
    read_services: true,
    update_appointments: true,
    update_notifications: true,
    update_roles: true,
    update_services: false
  }
end
