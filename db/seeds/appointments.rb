# frozen_string_literal: true

100.times do
  datetime = Faker::Time.between_dates(from: Date.today, to: 1.year.from_now)
  Appointment.create!(
    start: datetime,
    end: datetime + rand(1..8).hours,
    description: Faker::Lorem.sentence(word_count: 6),
    client_id: User.joins(:role).where(roles: { name: 'client' }).sample.id,
    freelancer_id: User.joins(:role).where(roles: { name: 'freelancer' }).sample.id
  )
end
