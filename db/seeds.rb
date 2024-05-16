# frozen_string_literal: true

def seed(file)
  load Rails.root.join('db', 'seeds', "#{file}.rb")
  p "Seeded #{file}"
end

puts "Seeding #{Rails.env} database..."
seed 'appointments'
seed 'client'
seed 'clients'
seed 'freelancer'
seed 'freelancers'
seed 'notifications'
seed 'reviews'
seed 'services'
puts 'All files successfully seeded'
