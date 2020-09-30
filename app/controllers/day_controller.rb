class DayController < ApplicationController
  before_action :set_today
  def monday
  end

  def tuesday
  end

  def wednesday
  end

  def thursday
  end

  def friday
  end

  private

  def set_today
    today_date = Date.today.strftime("%d-%m-%Y")
    week_day = Date.today.strftime("%A")
    orders = Order.all
    orders.each do |order|
      product_day = order.product.name
    end
    @orders = Order.where(meal_date: today_date)
    @days = ["Lunes", "Martes", "Miercoles", "Jueves", "Viernes"]
  end
end
