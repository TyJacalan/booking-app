# frozen_string_literal: true

# Completed appointments

completed_appointments = []

10.times do
  freelancer = User.joins(:role).where(roles: { name: 'freelancer' }).joins(:services).sample

  if freelancer && freelancer.services.any?
    appointment = {
      start: Date.today - rand(7..30).days,
      end: Date.today - rand(1..7).days,
      duration: rand(1..8),
      status: 'completed',
      is_completed: true,
      description: Faker::Lorem.sentence(word_count: 6),
      client_id: User.joins(:role).where(roles: { name: 'client' }).sample.id,
      freelancer_id: freelancer.id,
      service_id: freelancer.services.sample.id
    }

    completed_appointments << appointment
  end
end

Appointment.insert_all(completed_appointments)

# Create Reviews for completed appointments

Appointment.all.each do |appointment|
  reviews = [{
    overall_rating: Faker::Number.between(from: 1, to: 5),
    professionalism: Faker::Number.between(from: 1, to: 5),
    punctuality: Faker::Number.between(from: 1, to: 5),
    quality: Faker::Number.between(from: 1, to: 5),
    communication: Faker::Number.between(from: 1, to: 5),
    value: Faker::Number.between(from: 1, to: 5),
    subject: Faker::Lorem.sentence(word_count: 3),
    client_id: appointment.client_id,
    freelancer_id: appointment.freelancer_id,
    appointment_id: appointment.id,
    service_id: appointment.service_id
  },
  { overall_rating: Faker::Number.between(from: 1, to: 5),
    professionalism: Faker::Number.between(from: 1, to: 5),
    punctuality: Faker::Number.between(from: 1, to: 5),
    quality: Faker::Number.between(from: 1, to: 5),
    communication: Faker::Number.between(from: 1, to: 5),
    value: Faker::Number.between(from: 1, to: 5),
    subject: Faker::Lorem.sentence(word_count: 3),
    client_id: appointment.client_id,
    freelancer_id: appointment.freelancer_id,
    appointment_id: appointment.id,
    service_id: appointment.service_id }]

  Review.insert_all(reviews)
end

100.times do
  startdate = Faker::Time.between_dates(from: Date.today, to: 1.year.from_now)
  enddate = startdate + rand(1..7).days
  total_working_hours = ((enddate.to_date - startdate.to_date).to_i + 1) * 8

  freelancer = User.joins(:role).where(roles: { name: 'freelancer' }).joins(:services).sample
  next unless freelancer

  service = freelancer.services.sample
  appointment= Appointment.create!(
    start: startdate,
    end: enddate,
    duration: rand(1..total_working_hours),
    description: Faker::Lorem.sentence(word_count: 6),
    client_id: User.joins(:role).where(roles: { name: 'client' }).sample.id,
    freelancer_id: freelancer.id,
    service_id: service.id,
  )
end
