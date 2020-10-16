class AddSequenceToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :sequence, :integer
  end
end
