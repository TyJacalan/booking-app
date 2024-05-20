class Appointment < ApplicationRecord
  belongs_to :client, class_name: 'User', foreign_key: 'client_id'
  belongs_to :freelancer, class_name: 'User', foreign_key: 'freelancer_id'
  belongs_to :service

  validates :description, :start, :end, :duration, :service_id, :client_id, :freelancer_id, presence: true

  enum status: { pending: 0, accepted: 1, denied: 2, expired: 3, paid: 4, blocked: 5 }

  before_save :set_price
  before_destroy :validate_deletion

  private

  def set_price
    service = Service.find(service_id)
    price = service.price * duration
    service_fee = price * 0.025
    self.fee = price + service_fee
  end

  def validate_deletion
    if status != 'pending'
      errors.add(:base, 'Appointment cannot be deleted unless it is pending')
      throw(:abort)
    elsif start < 3.days.from_now
      errors.add(:base, 'Appointment cannot be deleted within three (3) days of the start date')
      throw(:abort)
    end
  end
end
