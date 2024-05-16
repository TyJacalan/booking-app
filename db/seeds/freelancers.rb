# frozen_string_literal: true

require 'faker'

shared_attributes = {
  password: 'password123!',
  password_confirmation: 'password123!',
  freelancer: true,
  client: false,
  country: 'Philippines'
}

10.times do
  attributes = shared_attributes.merge!(
    email: Faker::Internet.unique.email,
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    biography: Faker::Lorem.paragraph(sentence_count: 2),
    skills: Faker::Lorem.words(number: rand(1..5)),
    birthdate: Faker::Date.birthday(min_age: 18, max_age: 65),
    city: ['Cebu', 'Davao', 'Mactan', 'Makati', 'Mandaluyong', 'Taguig'].sample,
    mobile: Faker::PhoneNumber.phone_number
  )

  User.find_or_create_by!(email: attributes[:email]) do |user|
    user.assign_attributes(attributes)
  end
end
