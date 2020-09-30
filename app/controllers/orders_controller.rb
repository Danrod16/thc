class OrdersController < ApplicationController
  def weekly
    @orders = Order.all
  end

  def today
    today_date = date.today.strftime("%Y-%m-%d")
    meal_date = Order.meal_date
    @orders = Order.where(meal_date: today_date)
  end

  def index
    @orders = Order.all
  end
end
