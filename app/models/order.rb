class Order < ApplicationRecord
  require 'date'
  include PgSearch::Model
  belongs_to :product
  belongs_to :delivery, optional: true
  belongs_to :sticker, optional: true
  validates :meal_date, presence: true, format: { with: /\d{2}-\d{2}-\d{4}/,
                         error: 'Fecha invalida' }, on: :create

  after_update :set_sequence, if: :will_save_change_to_delivery_id?
  pg_search_scope :search_orders,
    against: [ :customer_name, :customer_email, :meal_date ],
    using: {
      tsearch: { prefix: true } # <-- now `superman batm` will return something!
    }

  def self.create_orders(client)
    # We fetch the orders JSON from webflow
    Order.fetch_orders(client)
    # Order.fetch_meals
    # we iterate through the Orders array
    @orders.each do |order|
      # We check that the order doesn't exist already in our database
      unless Order.order_exists?(order)
        # For each order we itterate through each purchased item
        order["purchasedItems"].each do |purchased_item|
          # We itterate through the quantity of identical purchased items
          purchased_item["count"].times do
            Order.order_type(order, purchased_item)
          end
        end
      end
    end
  end

  def set_sequence
    return unless delivery

    self.sequence = delivery.orders.count
    save
  end

  def grouped_orders
    "<td>#{meal_date}</td>
    <td>#{customer_name}</td>
    <td>#{delivery_address}</td>
    <td>#{notes}</td>".html_safe
  end

  def sticker_orders
    "<td>#{customer_name}</td>
    <td>#{product.meal_name.downcase.capitalize}</td>
    <td>#{meal_size.downcase.capitalize}</td>
    <td>#{meal_protein.downcase.capitalize}</td>
    <td>#{meal_custom.downcase.capitalize}</td>
    <td>#{notes}</td>".html_safe
  end

  private

  def self.fetch_orders(client)
    @orders = client.orders("5e9709a0ad0cd03f9c491ae6")
  end

  def self.order_exists?(order)
    return true if order['status'].include?('refunded') || Order.find_by(order_id: order['orderId'])
  end

  def self.order_type(order, purchased_item)
    category = Product.where(product_id: purchased_item["productId"]).first.category.name
    case category
    when "Combos"
      if Order.is_weekly?(purchased_item)
        Order.create_weekly(order, purchased_item)
      else
        Order.create_monthly(order, purchased_item)
      end
    when "Snacks"
      Order.new_snack(order, purchased_item)
    else
      Order.new_meal(order, purchased_item)
    end
  end


  def self.is_weekly?(purchased_item)
    purchased_item["productName"] == "Weekly Combo"
  end

  def self.is_monthly?(purchased_item)
    purchased_item["productName"] == "Monthly Combo"
  end

  def self.create_weekly(order, purchased_item)
    days = Order.fetch_days_weekly(order, 5)
    days.each do |day|
      Order.new_combo(order, purchased_item, day)
    end
  end

  def self.create_monthly(order, purchased_item)
    days = Order.fetch_days_monthly(order, 20)
      days.each do |day|
       Order.new_combo(order, purchased_item, day)
     end
   end

  def self.fetch_days_monthly(order, days)
    array = []
    full_date = order["acceptedOn"].split("T")[0]
    accepted_time = order["acceptedOn"].gsub("T", " ").split(".")[0].to_time
    limited_time = "#{full_date} 11:00:00".to_time
    if accepted_time > limited_time
      day = Date.parse(full_date) + 1
    else
      day = Date.parse(full_date)
    end
    while array.length < days
      if day.wday == 6 || day.wday == 0
        day = day.next_day
      else
        array << { name: day.strftime("%A"), date: day.strftime("%d-%m-%Y")}
        day = day.next_day
      end
    end
    array
  end

  def self.fetch_days_weekly(order, days)
    array = []
    full_date = order["acceptedOn"].split("T")[0]
    day = Date.parse(full_date)
    while array.length < days
      if day.wday == 6 || day.wday == 0
        day = day.next_day
      else
        array << { name: day.strftime("%A"), date: day.strftime("%d-%m-%Y")}
        day = day.next_day
      end
    end
    array
  end

  def self.new_combo(order, purchased_item, day)
    Order.create(customer_name: Order.format_name(order["customerInfo"]["fullName"]),
                 customer_email: order["customerInfo"]["email"],
                 meal_size: Order.variants(purchased_item["variantName"], "Size"),
                 meal_protein: Order.variants(purchased_item["variantName"], "Protein"),
                 meal_custom: Order.variants(purchased_item["variantName"], "Customise"),
                 notes: Order.format_notes(order["customData"][1]["textArea"]),
                 telephone: order["customData"][0]["textInput"],
                 delivery_address: Order.delivery_address(order),
                 category: "Meals",
                 order_id: order["orderId"],
                 product_id: Order.assign_day(day[:name]),
                 meal_date: day[:date])
  end

  def self.format_name(customer_name)
    customer_name.downcase.split(" ")
        .map { |e| e.capitalize }
        .join(" ")
  end

  def self.format_notes(note)
    if note.downcase.match?(/(^no$)|(^none$)|(^ninguno$)|(^nothing$)|(^nope$)/)
      "-"
    else
      note.downcase.capitalize
    end
  end

  def self.variants(variant_name, variant_type)
    regex = Regexp.new(".*#{variant_type}: ")
    new_format = variant_name.split(", ")
                              .find { |e| e["#{variant_type}:"]}
                              .gsub(regex, "")
                              .downcase
                              .capitalize
    if new_format.include?("No customisation")
      "-"
    elsif new_format.match?(/\(.*\)/)
      new_format.gsub(/ \(.*\)/, "")
    else
      new_format
    end
  end

  def self.delivery_address(order)
    address = order['allAddresses'][1]
    "#{address['line1']}, #{address['line2']}, #{address['postalCode']}"
  end

  def self.assign_day(name)
    Product.where(name: name).first.id
  end


  def self.new_snack(order, purchased_item)
    Order.create(customer_name: Order.format_name(order["customerInfo"]["fullName"]),
                 customer_email: order["customerInfo"]["email"],
                 meal_size: "-",
                 meal_protein: "-",
                 meal_custom: "-",
                 notes: Order.format_notes(order["customData"][1]["textArea"]),
                 telephone: order["customData"][0]["textInput"],
                 delivery_address: Order.delivery_address(order),
                 category: Order.assign_category(purchased_item),
                 order_id: order["orderId"],
                 product_id: Order.assign_product(purchased_item),
                 meal_date: Order.fetch_snack_date(order, purchased_item),
                 meal_name: Order.assign_product_name(purchased_item['productId']))
  end

  def self.new_meal(order, purchased_item)
    Order.create(customer_name: Order.format_name(order["customerInfo"]["fullName"]),
                 customer_email: order["customerInfo"]["email"],
                 meal_size: Order.variants(purchased_item["variantName"], "Size"),
                 meal_protein: Order.variants(purchased_item["variantName"], "Protein"),
                 meal_custom: Order.variants(purchased_item["variantName"], "Customise"),
                 notes: Order.format_notes(order["customData"][1]["textArea"]),
                 telephone: order["customData"][0]["textInput"],
                 delivery_address: Order.delivery_address(order),
                 category: Order.assign_category(purchased_item),
                 order_id: order["orderId"],
                 product_id: Order.assign_product(purchased_item),
                 meal_date: Order.fetch_date(order, purchased_item))
  end

  def self.fetch_snack_date(order, purchased_item)
    day = Date.parse(order["acceptedOn"].split("T")[0])
    if day.wday == 6 || day.wday == 0 #weekend
      if day.wday == 6
        day += 2
      elsif day.wday == 0
        day += 1
      end
    else
      accepted_day = order["acceptedOn"].split("T")[0]
      accepted_time = order["acceptedOn"].gsub("T", " ").split(".")[0].to_time
      limited_time = "#{accepted_day} 11:00:00".to_time
      if accepted_time > limited_time
        day += 1
      else
        day
      end
    end
    meal_date = day.strftime("%d-%m-%Y")
  end

  def self.fetch_date(order, purchased_item)
    array = []
    day = Date.parse(order["acceptedOn"].split("T")[0])
    if day.wday == 6
      day = day.next_day.next_day
    elsif day.wday == 0
      day = day.next_day
    end

    while day.wday < 6
      array << { name: day.strftime("%A"), date: day.strftime("%d-%m-%Y")}
      day = day.next_day
    end
    Order.assign_date(array, purchased_item)
  end

  def self.assign_date(array, purchased_item)
    meal_date = ""
    array.each do|e|
      if e[:name] == purchased_item["productName"]
        meal_date = e[:date]
      end
    end
    meal_date
  end

  def self.assign_product(purchased_item)
    Product.where(product_id: purchased_item['productId']).first.id
  end

  def self.assign_product_name(id)
    Product.find_by(product_id: id).meal_name.downcase.capitalize
  end

  def self.assign_category(purchased_item)
    Product.where(product_id: purchased_item['productId']).first.category.name
  end
end
