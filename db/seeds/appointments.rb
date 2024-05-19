# frozen_string_literal: true

100.times do
  startdate = Faker::Time.between_dates(from: Date.today, to: 1.year.from_now)
  enddate = startdate + rand(1..7).days
  total_working_hours = ((enddate.to_date - startdate.to_date).to_i + 1) * 8

  freelancer = User.joins(:role).where(roles: { name: 'freelancer' }).joins(:services).sample
  next unless freelancer

  service = freelancer.services.sample
  Appointment.create!(
    start: startdate,
    end: enddate,
    duration: rand(1..total_working_hours),
    description: Faker::Lorem.sentence(word_count: 6),
    client_id: User.joins(:role).where(roles: { name: 'client' }).sample.id,
    freelancer_id: freelancer.id,
    service_id: service.id
  )
end
