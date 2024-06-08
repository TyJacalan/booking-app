class Comment < ApplicationRecord
  belongs_to :client, class_name: 'User', foreign_key: 'client_id', optional: true
  belongs_to :freelancer, class_name: 'User', foreign_key: 'freelancer_id', optional: true
  belongs_to :appointment
  belongs_to :review

  # Association for polymorphic likes
  has_many :likes, as: :likeable

  validates :subject, presence: true
  validate :user_is_client_or_freelancer

  private

  def user_is_client_or_freelancer
    return if client_id.present? && appointment&.client_id == client_id
    return if freelancer_id.present? && appointment&.freelancer_id == freelancer_id

    errors.add(:base, 'Comment must be associated with either the client or the freelancer of the appointment')
  end
end
