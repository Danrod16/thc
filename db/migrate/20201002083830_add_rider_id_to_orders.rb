class AddRiderIdToOrders < ActiveRecord::Migration[6.0]
  def change
    add_reference :orders, :rider, foreign_key: true
  end
end
