service = Service.find(3) 
service.update(description: 'I will do my best for this service.')

puts "Service #{service.id} updated"

appointment = Appointment.find(5)
appointment.update(status: 4)

puts "Appointment #{appointment.id} updated"
