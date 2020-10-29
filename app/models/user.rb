class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :riders, dependent: :destroy
  validates :role, presence: true
  validates :user_name, presence: true
  enum role: [:admin, :cook, :rider]
  after_create :create_rider

  def create_rider
    if self.rider?
      Rider.create(name: self.first_name, user_id: self.id)
    end
  end
end
