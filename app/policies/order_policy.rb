class OrderPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def new?
    user.admin?
  end

  def create?
     new?
  end

  def index?
    return true
  end

  def show?
    return true
  end

  def edit?
    user.admin?
  end

  def destroy?
    user.admin?
  end
end