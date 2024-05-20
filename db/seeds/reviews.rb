# frozen_string_literal: true

50.times do
  freelancer = User.joins(:role).where(roles: { name: 'freelancer' }).joins(:services).sample
  next unless freelancer

  service = freelancer.services.sample
  client_id = User.joins(:role).where(roles: { name: 'client' }).sample.id

  Review.create!(
    rating: Faker::Number.between(from: 1, to: 5),
    subject: Faker::Lorem.sentence(word_count: 3),
    client_id:,
    freelancer_id: freelancer.id,
    service_id: service.id
  )
end
