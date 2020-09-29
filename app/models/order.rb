class Order < ApplicationRecord
  require 'date'

  belongs_to :product
  
  def self.order_exists?(order)
    Order.find_by(order_id: order['orderId'])
  end

  def self.create_orders
    # We fetch the orders JSON from webflow
    Order.fetch_orders
    # Order.fetch_meals
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
            # if purchased item is a weekly combo create 5 orders.
            if Order.is_weekly?(purchased_item)
              Order.create_weekly(order, purchased_item)
            else
            # we create a new order
              Order.new_order(purchased_item, order)
            end
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
    Order.create(customer_name: order["customerInfo"]["fullName"],
                 customer_email: order["customerInfo"]["email"],
                 meal_size: @meal_size,
                 meal_protein: @meal_protein,
                 meal_custom: @meal_custom,
                 notes: order["customData"][1]["textArea"],
                 telephone: order["customData"][0]["textInput"],
                 delivery_address: Order.delivery_address(order),
                 # macros: order["customerInfo"]["fullName"],
                 order_id: order["orderId"],
                 product_id: Order.assign_product(purchased_item))
  end

  def self.delivery_address(order)
    address = order['allAddresses'][1]
    "#{address['line1']}, #{address['line2']}, #{address['postalCode']}, #{address['city']}"
  end

  def self.is_weekly?(purchased_item)
    purchased_item["productName"] == "Weekly Combo"
  end

  def self.create_weekly(order, purchased_item)
    days = Order.fetch_week(order)
    days.each do |day|
     Order.create(customer_name: order["customerInfo"]["fullName"],
                 customer_email: order["customerInfo"]["email"],
                 meal_size: @meal_size,
                 meal_protein: @meal_protein,
                 meal_custom: @meal_custom,
                 notes: order["customData"][1]["textArea"],
                 telephone: order["customData"][0]["textInput"],
                 delivery_address: Order.delivery_address(order),
                 # macros: order["customerInfo"]["fullName"],
                 order_id: order["orderId"],
                 product_id: Order.assign_day(day[:name]),
                 meal_date: day[:date])
    end
  end

  def self.is_monthly?(purchased_item)
    purchased_item["productName"] == "Monthly Combo"
  end

  def self.create_monthly(order, purchased_item)
    days = Order.fetch_month(order)
      days.each do |day|
       Order.create(customer_name: order["customerInfo"]["fullName"],
                   customer_email: order["customerInfo"]["email"],
                   meal_size: @meal_size,
                   meal_protein: @meal_protein,
                   meal_custom: @meal_custom,
                   notes: order["customData"][1]["textArea"],
                   telephone: order["customData"][0]["textInput"],
                   delivery_address: Order.delivery_address(order),
                   # macros: order["customerInfo"]["fullName"],
                   product_id: Order.assign_day(day[:name]),
                   meal_date: day[:date])
     end
   end

  def self.assign_product(purchased_item)
    Product.where(product_id: purchased_item['productId']).first.id
  end

  def self.fetch_week(order)
    week = []
    full_date = order["acceptedOn"].split("T")[0]
    day = Date.parse(full_date)
    while week.length < 20
      if day.wday == 6 || day.wday == 0
        day = day.next_day
      else
        week << { name: day.strftime("%A"), date: day.strftime("%Y-%m-%d")}
        day = day.next_day
      end
    end
    week
  end

  def self.fetch_month(order)
    month = []
    full_date = order["acceptedOn"].split("T")[0]
    day = Date.parse(full_date)
    while month.length < 20
      if day.wday == 6 || day.wday == 0
        day = day.next_day
      else
        month << { name: day.strftime("%A"), date: day.strftime("%Y-%m-%d")}
        day = day.next_day
      end
    end
    month
  end

  def self.assign_day(name)
    Product.where(name: name).first.id
  end

  def self.variants(purchased_item)
    variants = purchased_item["variantName"].split(", ")
    @meal_size = variants.find { |e| e["Size"] }.gsub("Size: ", "").gsub("#{purchased_item['productName']}", "")
    @meal_protein = variants.find { |e| e["Protein"] }.gsub("Protein: ", "").gsub("#{purchased_item['productName']}", "")
    @meal_custom = variants.find { |e| e["Customise"] }.gsub("Customise ", "").gsub("#{purchased_item['productName']}", "")
  end
end
