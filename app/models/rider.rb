class Rider < ApplicationRecord
  belongs_to :user
  has_many :deliveries
  before_create :assign_name

  def assign_name
    self.name = self.user.first_name
  end
end

