class DaysController < ApplicationController
  before_action :set_days
  before_action :updated_at
  before_action :webflow_fetch

  def monday
    monday = assign_date("Monday")
    @path = "monday"
    @meals = Order.where(meal_date: monday, category: "Meals").order(created_at: :desc)
    @snacks = Order.where(meal_date: monday, category: "Snacks").order(created_at: :desc)
    @desserts = Order.where(meal_date: monday, category: "Desserts").order(created_at: :desc)
    @meals_summary = day_summary(monday)
    @snacks_summary = snacks_summary(monday)
    @desserts_summary = desserts_summary(monday)
    @meal_name = @meals.first.product.meal_name
    set_total_orders
    generate_pdf(@meals_summary, @snacks_summary, @desserts_summary, monday)
    set_json
  end

  def tuesday
    tuesday = assign_date("Tuesday")
    @path = "tuesday"
    @meals = Order.where(meal_date: tuesday, category: "Meals").order(created_at: :desc)
    @snacks = Order.where(meal_date: tuesday, category: "Snacks").order(created_at: :desc)
    @desserts = Order.where(meal_date: tuesday, category: "Desserts").order(created_at: :desc)
    @meals_summary = day_summary(tuesday)
    @snacks_summary = snacks_summary(tuesday)
    @desserts_summary = desserts_summary(tuesday)
    @meal_name = @meals.first.product.meal_name
    set_total_orders
    generate_pdf(@meals_summary, @snacks_summary, @desserts_summary, tuesday)
    set_json
  end

  def wednesday
    wednesday = assign_date("Wednesday")
    @path = "wednesday"
    @meals = Order.where(meal_date: wednesday, category: "Meals").order(created_at: :desc)
    @snacks = Order.where(meal_date: wednesday, category: "Snacks").order(created_at: :desc)
    @desserts = Order.where(meal_date: wednesday, category: "Desserts").order(created_at: :desc)
    @meals_summary = day_summary(wednesday)
    @snacks_summary = snacks_summary(wednesday)
    @desserts_summary = desserts_summary(wednesday)
    set_total_orders
    @meal_name = @meals.first.product.meal_name
    generate_pdf(@meals_summary, @snacks_summary, @desserts_summary, wednesday)
    set_json
  end

  def thursday
    thursday = assign_date("Thursday")
    @path = "thursday"
    @meals = Order.where(meal_date: thursday, category: "Meals").order(created_at: :desc)
    @snacks = Order.where(meal_date: thursday, category: "Snacks").order(created_at: :desc)
    @desserts = Order.where(meal_date: thursday, category: "Desserts").order(created_at: :desc)
    @meals_summary = day_summary(thursday)
    @snacks_summary = snacks_summary(thursday)
    @desserts_summary = desserts_summary(thursday)
    set_total_orders
    @meal_name = @meals.first.product.meal_name
    generate_pdf(@meals_summary, @snacks_summary, @desserts_summary, thursday)
    set_json
  end

  def friday
    friday = assign_date("Friday")
    @path = "friday"
    @meals = Order.where(meal_date: friday, category: "Meals").order(created_at: :desc)
    @snacks = Order.where(meal_date: friday, category: "Snacks").order(created_at: :desc)
    @desserts = Order.where(meal_date: friday, category: "Desserts").order(created_at: :desc)
    @meals_summary = day_summary(friday)
    @snacks_summary = snacks_summary(friday)
    @desserts_summary = desserts_summary(friday)
    set_total_orders
    @meal_name = @meals.first.product.meal_name
    generate_pdf(@meals_summary, @snacks_summary, @desserts_summary, friday)
    set_json
  end

  private

  def generate_pdf(meals_summary, snacks_summary, desserts_summary, day)
    respond_to do |format|
      format.html
      format.json
      format.pdf do
        pdf = OrdersPdf.new(meals_summary, snacks_summary, desserts_summary, day)
        send_data pdf.render, filename: "orders.pdf",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end

  def assign_date(day)
    week = []
    today = Date.today
    start = today - (today.wday - 1)
    5.times {
      week << { name: start.strftime("%A"), date: start.strftime("%d-%m-%Y") }
      start += 1
    }
    meal_date = ""
    week.each do|e|
      if e[:name] == day
        meal_date = e[:date]
      end
    end
    meal_date
  end

  def set_json
    respond_to do |format|
      format.html
      format.pdf
      format.json { render json: { meals_summary: @meals_summary,
                                   meals: @meals,
                                   snacks_summary: @snacks_summary,
                                   snacks: @snacks,
                                   desserts_summary: @desserts_summary,
                                   desserts: @desserts,
                                   total_orders: @total_orders,
                                   updated_at: @updated_at } }
    end
  end

  def set_days
    @days = [["Lunes", "Monday"], ["Martes", "Tuesday"], ["Miercoles", "Wednesday"], ["Jueves", "Thursday"], ["Viernes", "Friday"]]
  end

  def day_summary(day)
    size = ["Regular", "Large"]
    protein = ["-", "Vegetarian", "Vegan"]
    customisation = ["-", "Low carb", "High carb", "High protein", "Keto", "High protein/low carb", "High protein/high carb", "Extra veggies"]

    summary = []
    meal = []
    size.each do |meal_size|
      protein.each do |meal_protein|
        meal << "#{meal_size} #{meal_protein}"
        customisation.each do |meal_custom|
          total = Order.where("meal_date = ? AND meal_size = ? AND meal_protein = ? AND meal_custom = ?", day, meal_size, meal_protein, meal_custom).count
          meal << total
        end
        summary << meal
        meal = []
      end
    end
    summary
  end

  def snacks_summary(day)
    summary = []
    snack_names = Category.find_by(name: "Snacks").products.map { |e| e.name }
    snack_names.each do |e|
      snack = []
      snack << e
      id = Product.find_by(name: e)
      total = Order.where(meal_date: day, product_id: id).count
      snack << total
      summary << snack
    end
    summary
  end

  def desserts_summary(day)
    summary = []
    dessert_names = Category.find_by(name: "Desserts").products.map { |e| e.name }
    dessert_names.each do |e|
      dessert = []
      dessert << e
      id = Product.find_by(name: e)
      total = Order.where(meal_date: day, product_id: id).count
      dessert << total
      summary << dessert
    end
    summary
  end

  def set_total_orders
    @total_orders = @meals.count
  end

  def updated_at
    @updated_at = Time.zone.now.strftime("%H:%M")
  end

  def webflow_fetch
    FetchWebflow.get_webflow
  end
end
