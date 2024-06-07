# frozen_string_literal: true

25.times do
  categories = Category.order('RANDOM()').limit(rand(1..3))
  Service.create!(
    title: categories.map(&:title).join(', '),
    description: Faker::Lorem.sentence(word_count: 20),
    price: Faker::Number.between(from: 1000, to: 10_000),
    categories:,
    user_id: User.joins(:role).where(roles: { name: 'freelancer' }).sample.id
  )
end
