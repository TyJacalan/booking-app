class Service < ApplicationRecord
  belongs_to :user
  has_many :reviews

  attr_accessor :combined_search

  def self.ransackable_attributes(auth_object = nil)
    %w[title combined_search]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user]
  end
end
