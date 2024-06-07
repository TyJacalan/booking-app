class CreateClientRole < ActiveRecord::Migration[7.1]
  def up
    Role.find_or_create_by!(name: 'client') do |r|
      r.permissions = {
        create_appointments: true,
        create_services: false,
        create_blocked_dates: false,
        delete_appointments: true,
        delete_blocked_dates: false,
        delete_services: false,
        read_appointments: true,
        read_blocked_dates: true,
        read_notifications: true,
        read_services: true,
        update_appointments: true,
        update_notifications: true,
        update_roles: true,
        update_services: false
      }
    end
  end

  def down
    Role.find_by(name: 'client')&.destroy
  end
end
