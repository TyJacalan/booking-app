# frozen_string_literal: true

50.times do
  freelancer = User.joins(:role).where(roles: { name: 'freelancer' }).joins(:services).sample
  next unless freelancer

  service = freelancer.services.sample
  client = User.joins(:role).where(roles: { name: 'client' }).sample
  next unless client

  appointment = Appointment.where(client_id: client.id, service_id: service.id, status: 'completed').sample
  next unless appointment

  Review.create!(
    overall_rating: Faker::Number.between(from: 1, to: 5),
    professionalism: Faker::Number.between(from: 1, to: 5),
    punctuality: Faker::Number.between(from: 1, to: 5),
    quality: Faker::Number.between(from: 1, to: 5),
    communication: Faker::Number.between(from: 1, to: 5),
    value: Faker::Number.between(from: 1, to: 5),
    subject: Faker::Lorem.sentence(word_count: 3),
    client_id: client.id,
    service_id: service.id,
    appointment_id: appointment.id
  )
end
