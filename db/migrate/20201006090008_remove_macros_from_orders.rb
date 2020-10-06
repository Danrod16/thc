class RemoveMacrosFromOrders < ActiveRecord::Migration[6.0]
  def change
    remove_column :orders, :macros, :string
  end
end
