# frozen_string_literal: true

def seed(file)
  load Rails.root.join('db', 'seeds', "#{file}.rb")
  p "Seeded #{file}"
end

puts "Seeding #{Rails.env} database..."
seed 'roles'
seed 'client'
seed 'clients'
seed 'freelancer'
seed 'freelancers'
seed 'notifications'
seed 'services'
seed 'reviews'
seed 'appointments'
puts 'All files successfully seeded'
