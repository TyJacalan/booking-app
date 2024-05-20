class Service < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    %w[categories]
  end

  belongs_to :user
  has_many :reviews
end
