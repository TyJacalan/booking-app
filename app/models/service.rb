class Service < ApplicationRecord
  belongs_to :user
  has_many :reviews, dependent: :destroy, counter_cache: true
  has_many :appointments, dependent: :destroy
  has_one :overall_service_rating
  has_and_belongs_to_many :categories

  attr_accessor :combined_search

  validates :title, :description, :price, :categories, :user_id, presence: true
  validates :price, numericality: { greater_than: 0 }

  def self.ransackable_attributes(_auth_object = nil)
    %w[title combined_search]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[categories user]
  end

  def service_fee
    price * 0.025
  end

  def total_fee
    price + service_fee
  end

  def overall_rating
    if overall_service_rating.present?
      overall_service_rating.overall_rating
    else
      # If there is no overall service rating record, calculate the overall rating based on the counter cache
      total_reviews = reviews_count
      if total_reviews > 0
        sum_overall_rating = reviews.sum(&:overall_rating)
        sum_overall_rating / total_reviews
      else
        # Return 0 if there are no reviews
        0
      end
    end
  end

end
