# frozen_string_literal: true

Review.find_each do |review|
    begin
      if review.client_id && review.freelancer_id
        client_comment = Comment.create!(
          subject: Faker::Lorem.sentence(word_count: 3),
          client_id: review.client_id,
          appointment_id: review.appointment_id,
          review_id: review.id
        )
  
        freelancer_comment = Comment.create!(
          subject: Faker::Lorem.sentence(word_count: 3),
          freelancer_id: review.freelancer_id,
          appointment_id: review.appointment_id,
          review_id: review.id
        )

        puts "Comments created for review ##{review.id}"
      else
        puts "Skipping review with id #{review.id} because client_id or freelancer_id is missing"
      end
    rescue ActiveRecord::RecordInvalid => e
      puts "Failed to create comment for review ##{review.id}: #{e.message}"
    rescue => e
      puts "An unexpected error occurred for review ##{review.id}: #{e.message}"
    end
  end
  