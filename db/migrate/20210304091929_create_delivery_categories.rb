class CreateDeliveryCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :delivery_categories do |t|
      t.string :name
      t.references :rider, null: false, foreign_key: true

      t.timestamps
    end
  end
end
