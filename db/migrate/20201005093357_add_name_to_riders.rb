class AddNameToRiders < ActiveRecord::Migration[6.0]
  def change
    add_column :riders, :name, :string
  end
end
