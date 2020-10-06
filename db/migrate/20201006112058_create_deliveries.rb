class CreateDeliveries < ActiveRecord::Migration[6.0]
  def change
    create_table :deliveries do |t|
      t.string :name
      t.references :riders, foreign_key: true
      t.timestamps
    end
  end
end
