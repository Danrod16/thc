class DestroyDeliveryFromRider < ActiveRecord::Migration[6.0]
  def change
    remove_column :riders, :deliveries_id
    add_reference :orders, :delivery
  end
end
