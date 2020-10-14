class AddPrintedToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :printed, :boolean, default: false
  end
end
