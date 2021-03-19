class DeliveryCategory < ApplicationRecord
  belongs_to :rider
  has_many :deliveries, dependent: :destroy
  has_many :orders, dependent: :nullify
end
