class Product < ApplicationRecord
  belongs_to :category

  def self.fetch_products
    client = Webflow::Client.new(ENV['WEBFLOW_API'])
    client.items("5ec79e4a047417204a44efdb").each do |product|
      Product.create_products(product)
    end
  end

  def self.create_products(product)
    Product.create(product_id: product['_id'],
                   name: product['name'], description: product['description'],
                   meal_name: product['meal-name'],
                   category_id: Product.assign_category(product['category'].first))
  end

  def self.assign_category(category_id)
    Category.where(category_id: category_id).first.id
  end
end
