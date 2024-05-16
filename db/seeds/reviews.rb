# frozen_string_literal: true

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
