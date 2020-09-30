class OrdersController < ApplicationController
  def weekly
    @orders = Order.all
  end



  def index
    @orders = Order.all
  end
end
