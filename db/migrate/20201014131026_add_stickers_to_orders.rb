class AddStickersToOrders < ActiveRecord::Migration[6.0]
  def change
    add_reference :orders, :sticker, foreign_key: true
  end
end
