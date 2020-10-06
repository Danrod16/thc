class DayController < ApplicationController
  before_action :set_days
  before_action :webflow_fetch
  
  def monday
    monday = assign_date("Monday")
    @meals = Order.where(meal_date: monday, category: "Meals")
    @snacks = Order.where(meal_date: monday, category: "Snacks")
    @desserts = Order.where(meal_date: monday, category: "Desserts")
    @summary = day_summary(monday)
    @total_orders = Order.where(meal_date: monday).count
  end

  def tuesday
    tuesday = assign_date("Tuesday")
    @meals = Order.where(meal_date: tuesday, category: "Meals")
    @snacks = Order.where(meal_date: tuesday, category: "Snacks")
    @desserts = Order.where(meal_date: tuesday, category: "Desserts")
    @summary = day_summary(tuesday)
    @total_orders = Order.where(meal_date: tuesday).count
  end

  def wednesday
    wednesday = assign_date("Wednesday")
    @meals = Order.where(meal_date: wednesday, category: "Meals")
    @snacks = Order.where(meal_date: wednesday, category: "Snacks")
    @desserts = Order.where(meal_date: wednesday, category: "Desserts")
    @summary = day_summary(wednesday)
    @total_orders = Order.where(meal_date: wednesday).count
  end

  def thursday
    thursday = assign_date("Thursday")
    @meals = Order.where(meal_date: thursday, category: "Meals")
    @snacks = Order.where(meal_date: thursday, category: "Snacks")
    @desserts = Order.where(meal_date: thursday, category: "Desserts")
    @summary = day_summary(thursday)
    @total_orders = Order.where(meal_date: thursday).count
  end

  def friday
    friday = assign_date("Friday")
    @meals = Order.where(meal_date: friday, category: "Meals")
    @snacks = Order.where(meal_date: friday, category: "Snacks")
    @desserts = Order.where(meal_date: friday, category: "Desserts")
    @summary = day_summary(friday)
    @total_orders = Order.where(meal_date: friday).count
  end

  private

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

  def webflow_fetch
    FetchWebflow.get_webflow
  end
end
