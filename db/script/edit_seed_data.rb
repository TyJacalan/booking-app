# Remove duplcated categories
9.times do
  puts "Deleting #{Category.last.title}"
  Category.last.destroy
end

# Edit Service
s = Service.find(3)
s.description = "I will do my best for this service."
s.save

"Service #{s.id}'s description updated to #{s.description}"
