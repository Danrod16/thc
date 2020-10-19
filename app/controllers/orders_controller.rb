class OrdersController < ApplicationController
  def weekly
    @orders = Order.paginate(page: params[:page], per_page: 40)
  end

  def new
    @order = Order.new
    authorize @order
  end

  def create
    @order = Order.create(order_params)
    if @order.save
      redirect_to new_order_path
      flash[:alert] = "Nuevo pedido creado, Gracias Jessica!"
    else
      render :new
    end
    authorize @order
  end

  def index
    if params[:query].present?
      @orders = policy_scope(Order).search_orders(params[:query])
    else
      @orders = policy_scope(Order).paginate(page: params[:page], per_page: 40).order(created_at: :desc)
    end
    authorize @orders
  end

  def show
    @order = Order.find(params[:id])
    authorize @order
  end

  def edit
    @order = Order.find(params[:id])
    authorize @order
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
    authorize @order
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy
    authorize @order
  end

  private

  def order_params
    params.require(:order).permit(:customer_name, :customer_email, :meal_size, :meal_protein, :meal_custom, :notes, :telephone, :delivery_address, :order_id, :product_id, :meal_date, :category, :delivered, :printed)
  end

  def send_mailer
    mail = OrderMailer.with(order: @order).delivered
    mail.deliver_now
    redirect_to delivery_path(@order.delivery)
  end
end
