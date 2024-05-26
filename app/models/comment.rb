class Comment < ApplicationRecord
  belongs_to :client, class_name: 'User', foreign_key: 'client_id'
  belongs_to :freelancer, class_name: 'User', foreign_key: 'freelancer_id'
  belongs_to :appointment
  belongs_to :review

  # Association for polymorphic like
  has_many :likes, as: :likeable

  validates :subject, presence: true
  validates :user_is_client_or_freelancer

  private

  def user_is_client_or_freelancer
    unless appointment.client == user || appointment.freelancer == user
      errors.add(:user, 'must be either the client or the freelancer associated with the appointment')
    end
  end
end
