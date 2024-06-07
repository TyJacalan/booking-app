# frozen_string_literal: true

email = 'tyjacalan@gmail.com'
categories = Category.order('RANDOM()').limit(rand(1..3))
skills = categories.map(&:title)
attributes = {
  email:,
  first_name: 'freelancer',
  last_name: 'user',
  password: 'password123!',
  password_confirmation: 'password123!',
  biography: 'This is a fake freelancer.',
  skills:,
  birthdate: DateTime.new(1990, 12, 20),
  city: 'Makati',
  country: 'Philippines',
  mobile: '09762042654',
  role: Role.find_by(name: 'freelancer')
}

User.find_or_create_by!(email:) do |user|
  user.assign_attributes(attributes)
end
