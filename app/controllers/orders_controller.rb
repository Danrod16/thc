class OrdersController < ApplicationController
  def weekly
    @orders = Order.all
  end

  def index
    @orders = Order.all
  end

  def show(order)
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find(params[:id])
    @order.save
    if @order.save
      redirect_to deliveries_path
    end
  end



  private
end
