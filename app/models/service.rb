class Service < ApplicationRecord
  belongs_to :user
  has_many :reviews
  has_many :appointments
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
end
