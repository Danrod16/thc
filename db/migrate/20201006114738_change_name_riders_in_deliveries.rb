class ChangeNameRidersInDeliveries < ActiveRecord::Migration[6.0]
  def change
    remove_column :deliveries, :riders_id
    add_reference :deliveries, :rider
  end
end
