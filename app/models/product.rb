class Product < ApplicationRecord
  has_many :orders, dependent: :destroy
  belongs_to :category

  def self.fetch_products(client)
    client.items("5ec79e4a047417204a44efdb").each do |product|
      if Product.product_exists?(product)
        if !Product.product_update?(product)
          Product.update_product(product)
        end
      else
        Product.create_products(product)
       end
    end
  end

  def self.create_products(product)
    Product.create(product_id: product['_id'],
                   name: product['name'], description: product['description'],
                   meal_name: product['meal-name'],
                   category_id: Product.assign_category(product['category'].first))
  end

  def self.update_product(product)
  new_product = Product.find_by(product_id: product['_id'])
  new_product.update(name: product['name'], description: product['description'],
                 meal_name: product['meal-name'])
  end

  def self.assign_category(category_id)
    Category.where(category_id: category_id).first.id
  end

  def self.product_exists?(product)
    Product.find_by(product_id: product['_id'])
  end

  def self.product_update?(product)
    Product.find_by(meal_name: product['meal-name'])
  end
end
