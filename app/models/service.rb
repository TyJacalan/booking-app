class Service < ApplicationRecord
  belongs_to :user
  has_many :reviews

  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :categories, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[categories]
  end
end
