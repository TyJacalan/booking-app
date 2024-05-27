class Service < ApplicationRecord
  belongs_to :user
  has_many :reviews
  has_many :appointments

  attr_accessor :combined_search

  validates :title, :description, :price, :categories, :user_id, presence: true
  validates :price, numericality: { greater_than: 0 }

  def self.ransackable_attributes(auth_object = nil)
    %w[title combined_search]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user]
  end
end
