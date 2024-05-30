# frozen_string_literal: true

clients = User.joins(:role).where(roles: { name: 'client' })

100.times do |i|
  client = clients.sample
  next unless client

  appointment = client.client_appointments.sample
  next unless appointment

  unless appointment.is_completed?
    appointment.update(is_completed: true)
  end

  service = appointment.service
  freelancer = appointment.freelancer
  next unless service && freelancer

  Review.create!(
    overall_rating: Faker::Number.between(from: 1, to: 5),
    professionalism: Faker::Number.between(from: 1, to: 5),
    punctuality: Faker::Number.between(from: 1, to: 5),
    quality: Faker::Number.between(from: 1, to: 5),
    communication: Faker::Number.between(from: 1, to: 5),
    value: Faker::Number.between(from: 1, to: 5),
    subject: Faker::Lorem.sentence(word_count: 3),
    client_id: client.id,
    freelancer_id: freelancer.id,
    appointment_id: appointment.id,
    service_id: service.id
  )
end
