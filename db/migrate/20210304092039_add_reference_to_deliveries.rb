class AddReferenceToDeliveries < ActiveRecord::Migration[6.0]
  def change
    add_reference :deliveries, :delivery_category, null: false, foreign_key: true
  end
end
