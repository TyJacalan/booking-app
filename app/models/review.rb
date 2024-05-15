class Review < ApplicationRecord
  belongs_to :client, class_name: 'User', foreign_key: 'client_id'
  belongs_to :freelancer, class_name: 'User', foreign_key: 'freelancer_id'
  belongs_to :service, optional: true

  validates :rating, presence: true, inclusion: { in: 1..5 }
end
