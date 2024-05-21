class Appointment < ApplicationRecord
  belongs_to :client, class_name: 'User', foreign_key: 'client_id'
  belongs_to :freelancer, class_name: 'User', foreign_key: 'freelancer_id'
  belongs_to :service

  validates :description, :start, :end, :duration, :service_id, :client_id, :freelancer_id, presence: true

  enum status: { pending: 0, accepted: 1, denied: 2, expired: 3, paid: 4, blocked: 5 }

  before_save :set_price

  private

  def set_price
    service = Service.find(self.service_id)
    fee = service.price
    price = fee * self.duration
    service_fee = price * 0.025
    self.fee = price + service_fee
  end
end
