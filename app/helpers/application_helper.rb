module ApplicationHelper
  def time_ago_in_words(time)
    time_ago = Time.now - time
    if time_ago < 1.month
      weeks_ago = (time_ago / 1.week).to_i
      case weeks_ago
      when 0 then 'This week'
      when 1 then '1 week ago'
      when 2 then '2 weeks ago'
      when 3 then '3 weeks ago'
      when 4 then '4 weeks ago'
      else "#{weeks_ago} weeks ago"
      end
    else
      time.strftime("%B %Y")
    end
  end

  def users_who_liked(likeable_type, likeable_id)
    user_ids = Like.where(likeable_type: likeable_type, likeable_id: likeable_id).pluck(:user_id)
    User.where(id: user_ids).pluck(:full_name)
  end

  def users_who_liked_comment(comment)
    users_who_liked('Comment', comment.id)
  end

  def users_who_liked_review(review)
    users_who_liked('Review', review.id)
  end

  def users_who_commented_on_review(review)
    user_ids = Comment.where(review_id: review.id).pluck(:client_id, :freelancer_id).flatten.compact.uniq
    User.where(id: user_ids).pluck(:full_name)
  end

  def appointments_needing_review(user, service)
    Appointment.where(client_id: user.id, service_id: service.id, is_completed: true).left_joins(:review).where(reviews: { id: nil })
  end

  def can_comment?(user, review)
    user.id == review.client_id || user.id == review.freelancer_id
  end
end
