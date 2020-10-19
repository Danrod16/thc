class AddMealNameToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :meal_name, :string
  end
end
