class DestroyRiderFromOrders < ActiveRecord::Migration[6.0]
  def change
    remove_column :orders, :rider_id
    add_reference :riders, :deliveries, foreign_key: true
  end
end
