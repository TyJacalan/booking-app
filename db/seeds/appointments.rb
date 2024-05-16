# frozen_string_literal: true

100.times do
  Appointment.create!(
    date: Faker::Date.between(from: Date.today, to: 1.year.from_now),
    description: Faker::Lorem.sentence(word_count: 6),
    client_id: User.joins(:role).where(roles: { name: 'client' }).sample.id,
    freelancer_id: User.joins(:role).where(roles: { name: 'freelancer' }).sample.id
  )
end
