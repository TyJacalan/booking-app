class Comment < ApplicationRecord
  belongs_to :review
  belongs_to :user
  belongs_to :appointment

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
