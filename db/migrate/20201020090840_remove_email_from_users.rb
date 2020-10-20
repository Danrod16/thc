class RemoveEmailFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :email, :string
    add_column :users, :email, :string, default: "thc@mail.com"
  end
end
