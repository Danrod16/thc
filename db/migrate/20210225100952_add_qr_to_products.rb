class AddQrToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :qr, :string, default: "thc-QRCode.png"
  end
end
