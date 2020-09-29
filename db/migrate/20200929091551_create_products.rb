class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.string :meal_name
      t.string :product_id
      t.timestamps
    end
  end
end
