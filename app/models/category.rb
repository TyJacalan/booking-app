class Category < ApplicationRecord
  has_and_belongs_to_many :services

  def self.ransackable_attributes(auth_object = nil)
    %w[title]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[services]
  end
end
