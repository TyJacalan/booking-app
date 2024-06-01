class Like < ApplicationRecord
  include ActionView::RecordIdentifier

  belongs_to :user
  belongs_to :likeable, polymorphic: true
  # Polymorphic association, belongs_to review or comment

  validates :user_id, uniqueness: { scope: [:likeable_type, :likeable_id] }
  # Scope to polymorphic

  after_create :increment_likes_count
  after_create :broadcast_create_review, if: :likeable_is_review?
  after_destroy :broadcast_destroy_review, if: :likeable_is_review?
  after_destroy :decrement_likes_count

  private

  def increment_likes_count
    likeable.increment!(:likes_count)
  end

  def decrement_likes_count
    likeable.decrement!(:likes_count)
  end

  def broadcast_create_review
    broadcast_update_to(
      "review_modal_service_#{service_id}",
      target: "likes_count_review_#{likeable.id}",
      partial: 'likes/likes_count_review',
      locals: { review: likeable }
    )
  end

  def broadcast_destroy_review
    broadcast_update_to(
      "review_modal_service_#{service_id}",
      target: "likes_count_review_#{likeable.id}",
      partial: 'likes/likes_count_review',
      locals: { review: likeable }
    )
  end

  def service_id
    if likeable.is_a?(Review) || likeable.is_a?(Comment)
      likeable.service_id
    else
      nil
    end
  end

  def likeable_is_review?
    likeable_type == 'Review'
  end
end
