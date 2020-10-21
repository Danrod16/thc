class Sticker < ApplicationRecord
  has_many :orders, dependent: :nullify
end
