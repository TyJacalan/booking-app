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

    def users_who_liked_comment(comment)
        users = []
        Like.where(likeable_type: 'Comment', likeable_id: comment.id).each do |like|
          user = User.find_by(id: like.user_id)
          users << user.full_name if user
        end
        users
    end

    def users_who_liked_review(review)
        users = []
        Like.where(likeable_type: 'Review', likeable_id: review.id).each do |like|
          user = User.find_by(id: like.user_id)
          users << user.full_name if user
        end
        users
    end
end
