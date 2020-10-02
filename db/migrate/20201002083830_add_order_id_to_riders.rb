class AddOrderIdToRiders < ActiveRecord::Migration[6.0]
  def change
    add_reference :riders, :order, foreign_key: true
  end
end
