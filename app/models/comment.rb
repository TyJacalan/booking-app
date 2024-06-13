class Comment < ApplicationRecord
  include ActionView::RecordIdentifier

  belongs_to :client, class_name: 'User', foreign_key: 'client_id', optional: true
  belongs_to :freelancer, class_name: 'User', foreign_key: 'freelancer_id', optional: true
  belongs_to :appointment
  belongs_to :review

  # Association for polymorphic likes
  has_many :likes, as: :likeable

  validates :subject, presence: true
  validate :user_is_client_or_freelancer

  after_destroy :broadcast_destroy
  after_create :broadcast_create
  after_update :broadcast_update

  private

  def user_is_client_or_freelancer
    return if client_id.present? && review&.client_id == client_id
    return if freelancer_id.present? && review&.freelancer_id == freelancer_id

    errors.add(:base, 'Comment must be associated with either the client or the freelancer of the appointment')
  end

  def broadcast_destroy
    broadcast_replace_to(
      dom_id(review, :comments),
      target: dom_id(self, :review), 
      html: "<div class='hidden'></div>"
    )
  end

  def broadcast_create
      broadcast_prepend_to(
        dom_id(review, :comments),
        target: dom_id(review, :comments_container),
        partial: 'comments/comment',
        locals: { comment: self, review: review, client: self.client, freelancer: self.freelancer, current_user: self.client || self.freelancer }
      )
  end

  def broadcast_update
    broadcast_update_to(
      dom_id(review, :comments),
      target: dom_id(self, :review),
      partial: 'comments/comment',
      locals: { comment: self, review: review, client: self.client, freelancer: self.freelancer, current_user: self.client || self.freelancer }
    )
  end
end
