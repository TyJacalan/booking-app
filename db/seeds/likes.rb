# frozen_string_literal: true

# Get all users
users = User.all.to_a

# Iterate through reviews and create likes
Review.find_each do |review|
  rand(1..5).times do
    user = users.sample
    Like.create!(user: user, likeable: review) unless Like.exists?(user: user, likeable: review)
  end
end

# Iterate through comments and create likes
Comment.find_each do |comment|
  rand(1..5).times do
    user = users.sample
    Like.create!(user: user, likeable: comment) unless Like.exists?(user: user, likeable: comment)
  end
end
