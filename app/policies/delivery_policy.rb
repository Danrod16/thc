class DeliveryPolicy < ApplicationPolicy
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
    user.admin? || user.cook? || user.rider?
  end

  def show?
    return true
  end

  def edit?
    user.admin?
  end

  def update?
    edit?
  end

  def destroy?
    user.admin?
  end

  def reorganize?
    true
  end
end
