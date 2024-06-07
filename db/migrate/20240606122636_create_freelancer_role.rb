class CreateFreelancerRole < ActiveRecord::Migration[7.1]
  def up
    Role.find_or_create_by!(name: 'freelancer') do |r|
      r.permissions = {
        create_appointments: false,
        create_services: true,
        create_blocked_dates: true,
        delete_appointments: false,
        delete_blocked_dates: true,
        delete_services: true,
        read_appointments: true,
        read_blocked_dates: true,
        read_notifications: true,
        read_services: true,
        update_appointments: true,
        update_notifications: true,
        update_roles: true,
        update_services: true
      }
    end
  end

  def down
    Role.find_by(name: 'freelancer')&.destroy
  end
end
