class Category < ApplicationRecord
  has_many :products
  has_many :orders, through: :products

  def self.fetch_categories(client)
    client.items("5ec79e4a047417e66944efc5").each do |category|
      Category.create_categories(category)
    end
  end

  def self.create_categories(category)
    @category = Category.create(category_id: category['_id'], name: category['name'])
  end
end
