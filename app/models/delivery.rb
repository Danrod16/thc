class Delivery < ApplicationRecord
  belongs_to :rider
  has_many :orders
end
