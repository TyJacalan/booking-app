# frozen_string_literal: true

shared_attributes = {
  password: 'password123!',
  password_confirmation: 'password123!',
  role: Role.find_by(name: 'freelancer'),
  country: 'Philippines'
}

10.times do
  categories = Category.order('RANDOM()').limit(rand(1..3))
  skills = categories.map(&:title)
  attributes = shared_attributes.merge(
    email: Faker::Internet.unique.email,
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    biography: Faker::Lorem.paragraph(sentence_count: 2),
    skills:,
    birthdate: Faker::Date.birthday(min_age: 18, max_age: 65),
    city: %w[Cebu Davao Makati Quezon].sample,
    mobile: Faker::PhoneNumber.phone_number
  )

  User.find_or_create_by!(email: attributes[:email]) do |user|
    user.assign_attributes(attributes)
  end
end
