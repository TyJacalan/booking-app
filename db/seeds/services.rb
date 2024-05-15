# frozen_string_literal: true

25.times do
  Service.create!(
    title: Faker::Job.title,
    description: Faker::Lorem.sentence(word_count: 20),
    price: Faker::Number.between(from: 100, to: 10_000),
    categories: Faker::Lorem.words(number: rand(1..3)),
    user_id: User.where(freelancer: true).sample.id
  )
end
