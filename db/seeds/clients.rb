# frozen_string_literal: true

shared_attributes = {
  password: 'password123!',
  password_confirmation: 'password123!',
  country: 'Philippines'
}

50.times do
  attributes = shared_attributes.merge!(
    email: Faker::Internet.unique.email,
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    birthdate: Faker::Date.birthday(min_age: 18, max_age: 65),
    mobile: Faker::PhoneNumber.phone_number
  )

  User.find_or_create_by!(email: attributes[:email]) do |user|
    user.assign_attributes(attributes)
  end
end
