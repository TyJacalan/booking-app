# frozen_string_literal: true

100.times do
  Notification.create!(
    content: Faker::Lorem.sentence(word_count: 6),
    user_id: User.all.sample.id
  )
end
