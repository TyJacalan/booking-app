class Review < ApplicationRecord
  belongs_to :client, class_name: 'User', foreign_key: 'client_id'
  belongs_to :freelancer, class_name: 'User', foreign_key: 'freelancer_id'
  belongs_to :service
  belongs_to :appointment

  validates :overall_rating, :professionalism, :punctuality, :quality, :communication, :value, :subject, presence: true
  validates :overall_rating, :professionalism, :punctuality, :quality, :communication, :value, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }

  validate :client_must_match_appointment_client
  validate :appointment_must_be_completed
  validate :one_review_per_appointment

  has_many :comments
  has_many :likes, as: :likeable

  after_save :update_overall_service_rating
  after_destroy :update_overall_service_rating

  private

  def client_must_match_appointment_client
    if appointment.nil?
      errors.add(:appointment, "must be present")
    elsif client_id != appointment.client_id
      errors.add(:client, "must be the same as the client in the appointment")
    end
  end

  def appointment_must_be_completed
    unless appointment.is_completed?
      errors.add(:appointment, "must be completed before a review can be submitted")
    end
  end

  def one_review_per_appointment
    if appointment.review.present? && appointment.review != self
      errors.add(:appointment, "can only have one review")
    end
  end

  def review_after_appointment_date
    if appointment.present? && appointment.start > Time.current
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

    total_professionalism = reviews.sum(:professionalism)
    total_punctuality = reviews.sum(:punctuality)
    total_quality = reviews.sum(:quality)
    total_communication = reviews.sum(:communication)
    total_value = reviews.sum(:value)
    total_overall_rating = reviews.sum(:overall_rating)
    review_count = reviews.count

    overall_service_rating.update(
      professionalism: total_professionalism,
      punctuality: total_punctuality,
      quality: total_quality,
      communication: total_communication,
      value: total_value,
      overall_rating: total_overall_rating,
      count: review_count
    )
  end
end
