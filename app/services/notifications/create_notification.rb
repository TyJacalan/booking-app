module Notifications
  class CreateNotification
    def self.create_notification(user, content)
      Notification.create(
        user_id: user.id,
        content: content
      )
    end

    def self.notify_updated_appointment(appointment, user)
      content_for_client = "#{appointment.freelancer.full_name} #{appointment.status} your request."
      content_for_freelancer = "#{appointment.client.full_name} updated their request."
      content = user.role.name == 'freelancer' ? content_for_client : content_for_freelancer
      create_notification(appointment.client, content)
    end

    def self.notify_new_appointment(appointment)
      content = "#{appointment.client.full_name} submitted a request for your services. View details:"
      create_notification(appointment.freelancer, content)
    end
  end
end
