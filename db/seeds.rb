# frozen_string_literal: true

def seed(file)
  load Rails.root.join('db', 'seeds', "#{file}.rb")
  p "Seeded #{file}"
end

puts "Seeding #{Rails.env} database..."
seed 'roles'
seed 'client'
seed 'clients'
seed 'categories'
seed 'freelancer'
seed 'freelancers'
seed 'notifications'
seed 'services'
seed 'appointments'
# seed 'reviews'
# seed 'comments'
# seed 'likes'
puts 'All files successfully seeded'
