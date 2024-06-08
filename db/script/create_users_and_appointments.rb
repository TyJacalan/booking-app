# frozen_string_literal: true

# Create freelancer and client roles

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

puts "Created roles"

# Create categories

categories = [
  { title: 'Choreographer', icon: 'fa-solid fa-hands' },
  { title: 'Entertainer', icon: 'fa-solid fa-masks-theater' },
  { title: 'Event Host', icon: 'fa-solid fa-microphone' },
  { title: 'Event Planner', icon: 'fa-solid fa-wine-glass' },
  { title: 'Makeup Artist', icon: 'fa-solid fa-wand-magic-sparkles' },
  { title: 'Musician', icon: 'fa-solid fa-guitar' },
  { title: 'Photographer', icon: 'fa-solid fa-camera' },
  { title: 'Stylist', icon: 'fa-solid fa-person-dress-burst' },
  { title: 'Videographer', icon: 'fa-solid fa-video' }
]

categories.each do |category|
  Category.create_or_find_by!(category)
end

puts "Created categories"

# Create freelancer and client users

freelancer_email = 'freelancer@example.com'
categories = Category.order('RANDOM()').limit(rand(1..3))
skills = categories.map(&:title)
freelancer_attributes = {
  email: freelancer_email,
  first_name: 'freelancer',
  last_name: 'user',
  password: 'password123!',
  password_confirmation: 'password123!',
  biography: 'I am a freelancer. You can book my services!',
  skills:,
  birthdate: DateTime.new(1990, 12, 20),
  city: 'Makati',
  country: 'Philippines',
  mobile: '09762042654',
  role: Role.find_by(name: 'freelancer')
}

freelancer = User.find_or_create_by!(email: freelancer_email) do |user|
  user.assign_attributes(freelancer_attributes)
end

puts "#{freelancer.full_name} created."

client_email = 'client@example.com'
client_attributes = {
  email: client_email,
  first_name: 'client',
  last_name: 'user',
  password: 'password123!',
  password_confirmation: 'password123!',
  birthdate: DateTime.new(1990, 12, 20),
  mobile: '09274837463'
}

client = User.find_or_create_by!(email: client_email) do |user|
  user.assign_attributes(client_attributes)
end

puts "#{client.full_name} created."

# Clear Services and Appointments
Service.delete_all
Appointment.delete_all

# Create Service
categories = Category.order('RANDOM()').limit(rand(1..3))
service = Service.create!(
  title: categories.map(&:title).join(', '),
  description: "I will do my best #{categories.title}",
  price: 455,
  categories:,
  user_id: User.joins(:role).where(roles: { name: 'freelancer' }).sample.id
)

puts "#{service.title} created."

# Create Appointment
appointment= Appointment.create!(
  start: Date.new(2024, 05, 01),
  end: Date.new(2024, 05, 03),
  status: 1, # set as accepted
  duration: 2,
  description: 'This is a test appointment created for the demo.',
  client_id: client.id,
  freelancer_id: freelancer.id,
  service_id: service.id,
)

puts "Appontment #{appointment.id} created!"
