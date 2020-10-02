class RidersController < ApplicationController
  before_action :set_day, only: [:show, :deliveries]
  def index
  end

  def show
    @riders = Rider.all
    @rider = Rider.find(params[:id])
    @orders = Order.where(meal_date: assign_date(@day), rider_id: @rider.id)
  end

  def deliveries
    @riders = Rider.all
    @orders = Order.where(meal_date: assign_date(@day))
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

  def set_day
    @day = Date.today.strftime("%A")
  end

end
