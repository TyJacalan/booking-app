class Appointment < ApplicationRecord
  belongs_to :client, class_name: 'User', foreign_key: 'client_id'
  belongs_to :freelancer, class_name: 'User', foreign_key: 'freelancer_id'
  belongs_to :service

  has_one :review, dependent: :destroy
  has_many :comments, through: :review

  validates :description, :start, :end, :duration, :service_id, :client_id, :freelancer_id, presence: true
  validates :is_completed, inclusion: { in: [false] }, on: :create

  enum status: { pending: 0, accepted: 1, rejected: 2, expired: 3, completed: 4, blocked: 5 }

  before_destroy :validate_deletion
  before_save :set_price
  before_update :validate_update

  after_update :send_review_notification, if: :is_completed_changed_to_true?

  def total_hours
    ((self.end - start) / 3600).to_i
  end

  def fee_in_cents
    (fee * 100).to_i
  end

  private

  def set_price
    service = Service.find(service_id)
    price = service.price * duration
    service_fee = price * 0.025
    self.fee = price + service_fee
  end

  def validate_update
    return unless start < 1.days.from_now

    errors.add(:base, 'Appointment cannot be edited within one (1) day of the start date')
    throw(:abort)
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

  def send_review_notification
    UserMailer.review_notification(client, self).deliver_later
  end

  def is_completed_changed_to_true?
    saved_change_to_is_completed? && is_completed
  end
end
