class DayController < ApplicationController
  before_action :set_days
  before_action :webflow_fetch
  
  def monday
    monday = assign_date("Monday")
    @orders = Order.where(meal_date: monday)
    @summary = day_summary(monday)
  end

  def tuesday
    tuesday = assign_date("Tuesday")
    @orders = Order.where(meal_date: tuesday)
    @summary = day_summary(tuesday)
  end

  def wednesday
    wednesday = assign_date("Wednesday")
    @orders = Order.where(meal_date: wednesday)
    @summary = day_summary(wednesday)
  end

  def thursday
    thursday = assign_date("Thursday")
    @orders = Order.where(meal_date: thursday)
    @summary = day_summary(thursday)
  end

  def friday
    friday = assign_date("Friday")
    @orders = Order.where(meal_date: friday)
    @summary = day_summary(friday)
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
