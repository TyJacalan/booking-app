# frozen_string_literal: true

Appointment.find_each do |appointment|
  begin
    Rails.logger.info("Processing appointment ##{appointment.id}")
    appointment.update!(is_completed: true)
    Rails.logger.info("Appointment ##{appointment.id} marked as completed")

    if appointment.client && appointment.freelancer && appointment.service
      review = Review.create!(
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
      )
      Rails.logger.info("Review ##{review.id} created for appointment ##{appointment.id}")
    else
      Rails.logger.error("Missing associated objects for appointment ##{appointment.id}")
    end
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Failed to update appointment ##{appointment.id} or create review: #{e.message}")
  rescue => e
    Rails.logger.error("An unexpected error occurred for appointment ##{appointment.id}: #{e.message}")
  end
end
