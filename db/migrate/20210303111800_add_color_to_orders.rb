class AddColorToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :color, :string
  end
end
