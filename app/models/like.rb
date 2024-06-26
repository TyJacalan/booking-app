class Like < ApplicationRecord
    belongs_to :user
    belongs_to :likeable, polymorphic: true
    #polymorphic association, belongs_to review or comment

    validates :user_id, uniqueness: { scope: [:likeable_type, :likeable_id] }
    #scope to polymorphic

    after_create :increment_likes_count
    after_destroy :decrement_likes_count
  
    private
  
    def increment_likes_count
      likeable.increment!(:likes_count)
    end
  
    def decrement_likes_count
      likeable.decrement!(:likes_count)
    end
end