class DeliveryCategoryPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def new?
    true
  end

  def index?
    true
  end

  def new?
    true
  end

  def create?
    true
  end
end
