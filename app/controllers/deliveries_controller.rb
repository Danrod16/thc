class DeliveriesController < ApplicationController
  def index
    @delivery_groups = policy_scope(Delivery).all
    @riders = Rider.all
    @remaining_orders = Order.where(meal_date: Date.today.strftime("%d-%m-%Y"), delivery_id: nil).count
    authorize @delivery_groups
  end

  def show
    @delivery_group = Delivery.find(params[:id])
    @total_delivery_orders = Order.where(delivery_id: @delivery_group).count
    generate_pdf(@delivery_group, @total_delivery_orders)
    authorize @delivery_group
  end

  def new
    @delivery_group = Delivery.new
    @today_orders = Order.where(meal_date: Date.today.strftime("%d-%m-%Y"), delivery_id: nil)
    authorize @delivery_group
  end

  def create
    @delivery_group = Delivery.create(delivery_params)
    @today_orders = Order.where(meal_date: Date.today.strftime("%d-%m-%Y"), delivery_id: nil)
    if @delivery_group.save
      flash[:success] = "Grupo creado!"
      redirect_to new_delivery_path
    else
      flash[:alert] = "Error en creación"
      render :new
    end
    authorize @delivery_group
  end

  def edit
    @delivery_group = Delivery.find(params[:id])
    @today_orders = Order.where(meal_date: Date.today.strftime("%d-%m-%Y"))
    authorize @delivery_group
  end

  def update
    @delivery_group = Delivery.find(params[:id])
    @delivery_group.update(delivery_params)
    if @delivery_group.save
      redirect_to delivery_path(@delivery_group)
      flash[:success] = "Reparto modificado, Gracias #{current_user.first_name}!"
    else
      render :edit
      flash[:alert] = "Error al modificar reparto!"
    end
    authorize @delivery_group
  end

  def destroy
    @delivery_group = Delivery.find(params[:id])
    @delivery_group.destroy
    redirect_to deliveries_path
  end

  def reorganize
    @delivery_group = Delivery.find(params[:delivery_id])
    @orders = @delivery_group.orders
    params[:order_ids].each_with_index do |id, index|
      order = @orders.find(id)
      order.update(sequence: index + 1)
    end
    authorize @delivery_group
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

  def send_mailer
    mail = OrderMailer.with(order: @order).delivered
    mail.deliver_now
    redirect_to delivery_path(@order.delivery)
  end

  def generate_pdf(delivery_group, total_delivery_orders)
    respond_to do |format|
      format.html
      format.pdf do
        pdf = DeliveryPdf.new(delivery_group, total_delivery_orders)
        send_data pdf.render, filename: "delivery.pdf",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end
end
