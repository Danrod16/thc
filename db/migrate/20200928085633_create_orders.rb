class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.string :customer_name
      t.string :customer_email
      t.string :meal_name
      t.text :meal_description
      t.string :day
      t.integer :quantity
      t.string :meal_size
      t.string :meal_protein
      t.string :meal_custom
      t.text :notes
      t.string :telephone
      t.text :delivery_address
      t.string :macros
      t.string :order_id

      t.timestamps
    end
  end
end
