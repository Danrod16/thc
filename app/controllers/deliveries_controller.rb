class DeliveriesController < ApplicationController
  def index
    @delivery_groups = Delivery.all
    @riders = Rider.all
    @remaining_orders = Order.where(meal_date: Date.today.strftime("%d-%m-%Y"), delivery_id: nil).count
  end

  def show
    @delivery_group = Delivery.find(params[:id])
  end

  def new
    @delivery_group = Delivery.new
    @today_orders = Order.where(meal_date: Date.today.strftime("%d-%m-%Y"), delivery_id: nil)
  end

  def create
    @delivery_group = Delivery.create(delivery_params)
    if @delivery_group.save
      flash[:alert] = "Grupo creado!"
      redirect_to new_delivery_path
    else
      flash[:alert] = "Error en creación"
      render :new
    end
  end

  def edit
    @delivery_group = Delivery.find(params[:id])
    @today_orders = Order.where(meal_date: Date.today.strftime("%d-%m-%Y"))
  end

  def update
    @delivery_group = Delivery.find(params[:id])
    @delivery_group.update(delivery_params)
    if @delivery_group.save
      redirect_to delivery_path(@delivery_group)
      flash[:alert] = "Reparto modificado, Gracias #{current_user.first_name}!"
    else
      render :edit
      flash[:alert] = "Error al modificar reparto!"
    end
  end



  private

  def delivery_params
    params.require(:delivery).permit(:name, :rider_id, :order_ids => [])
  end

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
end
