class AddMealDateToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :meal_date, :string
  end
end
