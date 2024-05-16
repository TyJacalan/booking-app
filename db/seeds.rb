require 'faker'

50.times do
  User.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    password: 'password123!',
    freelancer: true,
    client: false,
    biography: Faker::Lorem.paragraph(sentence_count: 2),
    skills: Faker::Lorem.words(number: rand(1..5)),
    birthdate: Faker::Date.birthday(min_age: 18, max_age: 65),
    mobile: Faker::PhoneNumber.phone_number
  )
end

50.times do
  User.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    password: 'password123!',
    freelancer: false,
    client: true,
    birthdate: Faker::Date.birthday(min_age: 18, max_age: 65),
    mobile: Faker::PhoneNumber.phone_number
  )
end

cities = [
  'Mactan',
  'Cebu',
  'Makati',
  'Makati',
  'Manila',
  'Mandaluyong',
  'Taguig',
  'Davao'
]

cities.each do |city|
  User.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    password: 'password123!',
    freelancer: true,
    client: false,
    biography: Faker::Lorem.paragraph(sentence_count: 2),
    skills: Faker::Lorem.words(number: rand(1..5)),
    birthdate: Faker::Date.birthday(min_age: 18, max_age: 65),
    city: city,
    country: 'Philippines',
    mobile: Faker::PhoneNumber.phone_number
  )
end

25.times do
  Service.create!(
    title: Faker::Job.title,
    description: Faker::Lorem.sentence(word_count: 20),
    price: Faker::Number.between(from: 100, to: 10_000),
    categories: Faker::Lorem.words(number: rand(1..3)),
    user_id: User.where(freelancer: true).sample.id
  )
end

100.times do
  Appointment.create!(
    date: Faker::Date.between(from: Date.today, to: 1.year.from_now),
    description: Faker::Lorem.sentence(word_count: 6),
    client_id: User.where(client: true).sample.id,
    freelancer_id: User.where(freelancer: true).sample.id
  )
end

100.times do
  Notification.create!(
    content: Faker::Lorem.sentence(word_count: 6),
    user_id: User.all.sample.id
  )
end

50.times do
  freelancer = User.includes(:services).where(freelancer: true).where.not(services: { id: nil }).sample
  service = freelancer.services.sample

  Review.create!(
    rating: Faker::Number.between(from: 1, to: 5),
    subject: Faker::Lorem.sentence(word_count: 3),
    client_id: User.where(client: true).sample.id,
    freelancer_id: freelancer.id,
    service_id: service.id
  )
end

Role.find_or_create_by!(name: "freelancer") do |r|
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

Role.find_or_create_by!(name: "client") do |r|
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
