class CommentPolicy < ApplicationPolicy
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

    def show?
        true
    end

    def new?
        @record.client_id == @user.id || @record.freelancer_id == @user.id
    end

    def create?
        @record.client_id == @user.id || @record.freelancer_id == @user.id
    end

    def update?
        @record.client_id == @user.id || @record.freelancer_id == @user.id
    end

    def destroy?
        @record.client_id == @user.id || @record.freelancer_id == @user.id
    end
end