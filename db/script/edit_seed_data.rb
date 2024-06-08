# Remove duplcated categories
9.times do
  puts "Deleting #{Category.last.title}"
  Category.last.destroy
end
