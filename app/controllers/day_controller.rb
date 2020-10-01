class DayController < ApplicationController
  before_action :set_days
  before_action :webflow_fetch
  def monday
    @orders = Order.where(meal_date: assign_date("Monday"))
  end

  def tuesday
    @orders = Order.where(meal_date: assign_date("Tuesday"))
  end

  def wednesday
    @orders = Order.where(meal_date: assign_date("Wednesday"))
  end

  def thursday
    @orders = Order.where(meal_date: assign_date("Thursday"))
  end

  def friday
    @orders = Order.where(meal_date: assign_date("Friday"))
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
    @days = ["Lunes", "Martes", "Miercoles", "Jueves", "Viernes"]
  end

  def set_variables(order)
    size = ["Regular", "Large"]
    custom = [""]
    @meal_count = @orders.where(meal_size: order.meal_size, meal_custom: order.meal_custom, meal_protein: order.meal_protein).count
  end

  def webflow_fetch
    FetchWebflow.get_webflow
  end
end
