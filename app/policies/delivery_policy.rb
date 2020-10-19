class DeliveryPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end
  def new?
    user.role == "admin"
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
    user.role == "admin"
  end

  def destroy
    user.role == "admin"
  end
end
