class AddReferenceToOrders < ActiveRecord::Migration[6.0]
  def change
    add_reference :orders, :delivery_category, null: true, foreign_key: true
  end
end
