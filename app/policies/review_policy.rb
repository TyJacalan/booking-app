class ReviewPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    true
  end

  def recent_10_reviews?
    true
  end

  def most_rated_reviews?
    true
  end

  def least_rated_reviews?
    true
  end

  def show?
    true
  end

  def new?
    @record.client_id == @user.id
  end

  def create?
    @record.client_id == @user.id
  end

  def update?
    @record.client_id == @user.id
  end

  def destroy?
    @record.client_id == @user.id
  end
end
