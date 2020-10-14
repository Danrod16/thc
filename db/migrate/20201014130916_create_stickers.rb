class CreateStickers < ActiveRecord::Migration[6.0]
  def change
    create_table :stickers do |t|

      t.timestamps
    end
  end
end
