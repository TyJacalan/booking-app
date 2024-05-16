# frozen_string_literal: true

Role.find_or_create_by!(name: 'freelancer') do |r|
  r.permissions = {
    create_services: true,
    read_services: true,
    update_services: true,
    delete_services: true,
    create_appointments: true,
    read_appointments: true,
    update_appointments: true,
    delete_appointments: false
  }
end

Role.find_or_create_by!(name: 'client') do |r|
  r.permissions = {
    create_services: false,
    read_services: true,
    update_services: false,
    delete_services: false,
    create_appointments: true,
    read_appointments: true,
    update_appointments: true,
    delete_appointments: false
  }
end
