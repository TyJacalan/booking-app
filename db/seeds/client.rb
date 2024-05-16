# frozen_string_literal: true

require 'faker'

email = 'client@example.com'
attributes = {
  email: email,
  first_name: 'client',
  last_name: 'user',
  password: 'password123!',
  password_confirmation: 'password123!',
  freelancer: false,
  client: true,
  birthdate: Faker::Date.birthday(min_age: 18, max_age: 65),
  mobile: Faker::PhoneNumber.phone_number
}

User.find_or_create_by!(email: email) do |user|
  user.assign_attributes(attributes)
end
