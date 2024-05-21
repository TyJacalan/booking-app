class Review < ApplicationRecord
  belongs_to :client, class_name: 'User', foreign_key: 'client_id'
  belongs_to :service
  belongs_to :appointment

  validates_presence :subject
  validates :rating, presence: true, inclusion: { in: 1..5 }
  validate :client_must_match_appointment_client
  validate :appointment_must_be_completed
  validate :one_review_per_appointment

  has_many :comments
  has_many :likes, as: :likeable

  private

  def client_must_match_appointment_client
    unless client == appointment.client
      errors.add(:client, "must be the same as the client in the appointment")
    end
  end

  def appointment_must_be_completed
    unless appointment.completed?
      errors.add(:appointment, "must be completed before a review can be submitted")
    end
  end

  def one_review_per_appointment
    if appointment.review.present? && appointment.review != self
      errors.add(:appointment, "can only have one review")
    end
  end
end
