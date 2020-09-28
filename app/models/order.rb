class Order < ApplicationRecord

  def self.order_exists?(order)
    Order.find_by(order_id: order['orderId'])
  end

  def self.create_orders
    # We fetch the orders JSON from webflow
    Order.fetch_orders
    Order.fetch_meals
    # we iterate through the Orders array
    @orders.each do |order|
      # We check that the order doesn't exist already in our database
      unless Order.order_exists?(order)
        # For each order we itterate through each purchased item
        order["purchasedItems"].each do |purchased_item|
          # we get the attributes for the meal object in items from webflow
          # We strip and format the variables from each purchased item
          Order.variants(purchased_item)
          # We itterate through the quantity of identical purchased items
          purchased_item["count"].times do
            # we create a new order
            Order.new_order(purchased_item, order)
          end
        end
      end
    end
  end

  private

  def self.fetch_orders
    @client = Webflow::Client.new(ENV['WEBFLOW_API'])
    @orders = @client.orders("5e9709a0ad0cd03f9c491ae6")

  end

  def self.new_order(purchased_item, order)
    Order.assign_meal(purchased_item)
    Order.create(customer_name: order["customerInfo"]["fullName"],
    customer_email: order["customerInfo"]["email"],
    meal_name: @assigned_meal[:meal_name],
    meal_description: @assigned_meal[:meal_description],
    day: purchased_item["productName"],
    quantity: purchased_item["count"],
    meal_size: @meal_size,
    meal_protein: @meal_protein,
    meal_custom: @meal_custom,
    notes: order["customData"][1]["textArea"],
    telephone: order["customData"][0]["textInput"],
    delivery_address: Order.delivery_address(order),
    # macros: order["customerInfo"]["fullName"],
    order_id: order["orderId"])
  end

  def self.delivery_address(order)
    address = order['allAddresses'][1]
    "#{address['line1']}, #{address['line2']}, #{address['postalCode']}, #{address['city']}"
  end

  def self.fetch_meals
    @meal_array = []
    @client.items("5ec79e4a047417204a44efdb").each do |meal|
      meal_info = {meal_id: meal['_id'], meal_description: meal['description'], meal_name: meal['meal-name']}
      @meal_array << meal_info
    end
  end

  def self.is_weekly?(purchased_item)
  end

  def self.is_monthly?(purchased_item)

  def self.assign_meal(purchased_item)
    @assigned_meal = @meal_array.find { |meal| meal[:meal_id] == purchased_item['productId'] }
  end

  def self.variants(purchased_item)
    variants = purchased_item["variantName"].split(", ")
    @meal_size = variants[2]
    @meal_protein = variants[1]
    @meal_custom = variants[0]
  end
end
