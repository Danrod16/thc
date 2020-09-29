class RemoveFieldsFromOrders < ActiveRecord::Migration[6.0]
  def change
    remove_column :orders, :meal_name
    remove_column :orders, :meal_description
    remove_column :orders, :day
  end
end
