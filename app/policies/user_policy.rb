class UserPolicy < ApplicationPolicy
  # NOTE: Up to Pundit v2.3.1, the inheritance was declared as
  # `Scope < Scope` rather than `Scope < ApplicationPolicy::Scope`.
  # In most cases the behavior will be identical, but if updating existing
  # code, beware of possible changes to the ancestors:
  # https://gist.github.com/Burgestrand/4b4bc22f31c8a95c425fc0e30d7ef1f5

  def index?
    user.present?
  end

  def show?
    true
  end

  def update?
    user&.role&.update_roles
  end

  def services?
    user&.role&.create_services
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end
end
