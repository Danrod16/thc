class OrdersController < ApplicationController
  def weekly
    @orders = Order.paginate(page: params[:page], per_page: 40)
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.create(order_params)
    if @order.save
      redirect_to new_order_path
      flash[:alert] = "Nuevo pedido creado, Gracias Jessica!"
    else
      render :new
    end
  end

  def index
    if params[:query].present?
      @orders = Order.search_orders(params[:query])
    else
      @orders = Order.paginate(page: params[:page], per_page: 40).order(created_at: :desc)
    end
  end

  def show
    @order = Order.find(params[:id])
  end

  def edit
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find(params[:id])
    @order.update(order_params)
    if @order.save
      if @order.delivered == true
        send_mailer
      else
        redirect_to deliveries_path
        flash[:alert] = "Pedido modificado, Gracias #{current_user.first_name}!"
      end
    else
      render :edit
      flash[:alert] = "Error al modificar pedido!"
    end
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy
  end



  private

  def order_params
    params.require(:order).permit(:customer_name, :customer_email, :meal_size, :meal_protein, :meal_custom, :notes, :telephone, :delivery_address, :order_id, :product_id, :meal_date, :category, :delivered)
  end

  def send_mailer
    mail = OrderMailer.with(order: @order).delivered
    mail.deliver_now
    redirect_to delivery_path(@order.delivery)
  end
end
