class Appointment < ApplicationRecord
  belongs_to :client, class_name: 'User', foreign_key: 'client_id'
  belongs_to :freelancer, class_name: 'User', foreign_key: 'freelancer_id'

  # belongs_to :client, class_name: 'User', foreign_key: 'client_id'
  #has_one :review
  #has_many :comments through :review
  #end_date
  #review_notification_sent
end
