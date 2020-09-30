class OrdersController < ApplicationController

  # def new
  #   @order = Order.new
  # end

  # def create
  #   @order = Order.new()
  # end
  def weekly
    @orders = Order.all
  end

  def today
    today_date = date.today.strftime("%Y-%m-%d")
    meal_date = Order.meal_date
    @orders = Order.where(meal_date: today_date)
  end

  def raw_data
    Order.create_orders
    @orders = Order.all
  end
end
