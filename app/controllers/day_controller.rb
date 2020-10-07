class DayController < ApplicationController
  before_action :set_days
  before_action :webflow_fetch
  
  def monday
    monday = assign_date("Monday")
    @meals = Order.where(meal_date: monday, category: "Meals")
    @snacks = Order.where(meal_date: monday, category: "Snacks")
    @desserts = Order.where(meal_date: monday, category: "Desserts")
    @meals_summary = day_summary(monday)
    @snacks_summary = snacks_summary(monday)
    @desserts_summary = desserts_summary(monday)
    @total_orders = Order.where(meal_date: monday).count
    generate_pdf(@meals_summary, @snacks_summary, @desserts_summary, monday)
  end

  def tuesday
    tuesday = assign_date("Tuesday")
    @meals = Order.where(meal_date: tuesday, category: "Meals")
    @snacks = Order.where(meal_date: tuesday, category: "Snacks")
    @desserts = Order.where(meal_date: tuesday, category: "Desserts")
    @meals_summary = day_summary(tuesday)
    @snacks_summary = snacks_summary(tuesday)
    @desserts_summary = desserts_summary(tuesday)
    @total_orders = Order.where(meal_date: tuesday).count
    generate_pdf(@meals_summary, @snacks_summary, @desserts_summary, tuesday)
  end

  def wednesday
    wednesday = assign_date("Wednesday")
    @meals = Order.where(meal_date: wednesday, category: "Meals")
    @snacks = Order.where(meal_date: wednesday, category: "Snacks")
    @desserts = Order.where(meal_date: wednesday, category: "Desserts")
    @meals_summary = day_summary(wednesday)
    @snacks_summary = snacks_summary(wednesday)
    @desserts_summary = desserts_summary(wednesday)
    @total_orders = Order.where(meal_date: wednesday).count
    generate_pdf(@meals_summary, @snacks_summary, @desserts_summary, wednesday)
  end

  def thursday
    thursday = assign_date("Thursday")
    @meals = Order.where(meal_date: thursday, category: "Meals")
    @snacks = Order.where(meal_date: thursday, category: "Snacks")
    @desserts = Order.where(meal_date: thursday, category: "Desserts")
    @meals_summary = day_summary(thursday)
    @snacks_summary = snacks_summary(thursday)
    @desserts_summary = desserts_summary(thursday)
    @total_orders = Order.where(meal_date: thursday).count
    generate_pdf(@meals_summary, @snacks_summary, @desserts_summary, thursday)
  end

  def friday
    friday = assign_date("Friday")
    @meals = Order.where(meal_date: friday, category: "Meals")
    @snacks = Order.where(meal_date: friday, category: "Snacks")
    @desserts = Order.where(meal_date: friday, category: "Desserts")
    @meals_summary = day_summary(friday)
    @snacks_summary = snacks_summary(friday)
    @desserts_summary = desserts_summary(friday)
    @total_orders = Order.where(meal_date: friday).count
    generate_pdf(@meals_summary, @snacks_summary, @desserts_summary, friday)
  end

  private

  def generate_pdf(meals_summary, snacks_summary, desserts_summary, day)
    respond_to do |format|
      format.html
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

  def set_days
    @days = [["Lunes", "Monday"], ["Martes", "Tuesday"], ["Miercoles", "Wednesday"], ["Jueves", "Thursday"], ["Viernes", "Friday"]]
  end

  def day_summary(day)
    size = ["regular", "large"]
    protein = ["-", "vegetarian", "vegan"]
    customisation = ["-", "low carb", "high carb", "high protein", "keto", "high protein/low carb"]

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

  def webflow_fetch
    FetchWebflow.get_webflow
  end
end
