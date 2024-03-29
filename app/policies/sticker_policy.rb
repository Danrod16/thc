class StickerPolicy < ApplicationPolicy
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
    user.admin? || user.cook?
  end

  def show?
    user.admin? || user.cook?
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
end
