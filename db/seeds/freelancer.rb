# frozen_string_literal: true

email = 'freelancer@example.com'
attributes = {
  email:,
  first_name: 'freelancer',
  last_name: 'user',
  password: 'password123!',
  password_confirmation: 'password123!',
  biography: Faker::Lorem.paragraph(sentence_count: 2),
  skills: Faker::Lorem.words(number: rand(1..5)),
  birthdate: Faker::Date.birthday(min_age: 18, max_age: 65),
  city: 'Makati',
  country: 'Philippines',
  mobile: Faker::PhoneNumber.phone_number,
  role: Role.find_by(name: 'freelancer')
}

User.find_or_create_by!(email:) do |user|
  user.assign_attributes(attributes)
end
