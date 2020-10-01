class Category < ApplicationRecord
  has_many :products, dependent: :destroy
  has_many :orders, through: :products

  def self.fetch_categories(client)
    client.items("5ec79e4a047417e66944efc5").each do |category|
      unless Category.category_exists?(category)
        Category.create_categories(category)
      end
    end
  end

  def self.create_categories(category)
    @category = Category.create(category_id: category['_id'], name: category['name'])
  end

  def self.category_exists?(category)
    Category.find_by(category_id: category['_id'])
  end
end

