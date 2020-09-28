class OrdersController < ApplicationController

  # def new
  #   @order = Order.new
  # end

  # def create
  #   @order = Order.new()
  # end

  def raw_data
    Order.create_orders
    @orders = Order.all
  end
end
