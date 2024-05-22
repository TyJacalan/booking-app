class Review < ApplicationRecord
  belongs_to :client, class_name: 'User', foreign_key: 'client_id'
  belongs_to :service
  belongs_to :appointment

  validates_presence :subject

  validate :client_must_match_appointment_client
  validate :appointment_must_be_completed
  validate :one_review_per_appointment

  validates :overall_rating, :professionalism, :punctuality, :quality, :communication, :value, presence: true
  validates :overall_rating, :professionalism, :punctuality, :quality, :communication, :value, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }

  has_many :comments
  has_many :likes, as: :likeable

  after_save :update_overall_service_rating
  after_destroy :update_overall_service_rating

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

  def review_after_appointment_date
    if appointment.present? && appointment.start_date > Time.current
      errors.add(:base, "Review can't be created before the appointment date")
    end
  end

  def appointment_completed
    if appointment.present? && appointment.end > Time.current
      errors.add(:base, "Appointment must be completed before leaving a review")
    end
  end

  def update_overall_service_rating
    overall_service_rating = service.overall_service_rating || service.create_overall_service_rating

    reviews = service.reviews

    total_cleanliness = reviews.sum(:cleanliness)
    total_accuracy = reviews.sum(:accuracy)
    total_checkin = reviews.sum(:checkin)
    total_communication = reviews.sum(:communication)
    total_location = reviews.sum(:location)
    total_value = reviews.sum(:value)
    total_overall_rating = reviews.sum(:overall_rating)
    review_count = reviews.count

    overall_rating.update(
      cleanliness: total_cleanliness,
      accuracy: total_accuracy,
      checkin: total_checkin,
      communication: total_communication,
      location: total_location,
      value: total_value,
      count: review_count
    )
  end
end
