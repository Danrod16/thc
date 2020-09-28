class Order < ApplicationRecord

  def hello
    puts "hello"
  end

  def self.create_orders
    # We fetch the orders JSON from webflow
    Order.fetch_orders
    # we iterate through the Orders array
    @orders.each do |order|
      # For each order we itterate through each purchased item
      order["purchasedItems"].each do |purchased_item|
        # we get the attributes for the meal object in items from webflow
        Order.meal(purchased_item)
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

  private

  def self.fetch_orders
    @client = Webflow::Client.new(ENV['WEBFLOW_API'])
    @orders = @client.orders("5e9709a0ad0cd03f9c491ae6")
  end

  def self.new_order(purchased_item, order)
     Order.create(customer_name: order["customerInfo"]["fullName"],
     customer_email: order["customerInfo"]["email"],
     meal_name: @meal["meal-name"],
     meal_description: @meal["description"],
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

  def self.meal(purchased_item)
    @meal = @client.item("5ec79e4a047417204a44efdb", "#{purchased_item['productId']}")
  end

  def self.variants(purchased_item)
    variants = purchased_item["variantName"].split(", ")
    @meal_size = variants[2]
    @meal_protein = variants[1]
    @meal_custom = variants[0]
  end
end
