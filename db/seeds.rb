# frozen_string_literal: true

def seed(file)
  load Rails.root.join('db', 'seeds', "#{file}.rb")
  p "Seeded #{file}"
end

puts "Seeding #{Rails.env} database..."
seed 'client'
seed 'clients'
seed 'freelancer'
seed 'freelancers'
seed 'appointments'
seed 'notifications'
seed 'reviews'
seed 'services'
puts 'All files successfully seeded'

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
