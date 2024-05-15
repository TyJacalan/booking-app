# frozen_string_literal: true

100.times do
  Appointment.create!(
    date: Faker::Date.between(from: Date.today, to: 1.year.from_now),
    description: Faker::Lorem.sentence(word_count: 6),
    client_id: User.where(client: true).sample.id,
    freelancer_id: User.where(freelancer: true).sample.id
  )
end
