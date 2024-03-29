  class OrdersController < ApplicationController
  after_action :create_combos, only: [:create]

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
      flash[:alert] = "Nuevo pedido creado, Gracias #{current_user.first_name}!!"
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
        redirect_to order_path(@order)
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
    redirect_to orders_path
    authorize @order
  end

  private

  def order_params
    params.require(:order).permit(:customer_name, :customer_email, :meal_size, :meal_protein, :meal_custom, :notes, :telephone, :delivery_address, :order_id, :product_id, :meal_date, :category, :delivered, :printed)
  end

  def send_mailer
    mail = OrderMailer.with(order: @order).delivered
    mail.deliver_now
    redirect_to delivery_category_deliveries_path(@order.delivery_category.id)
  end

  def create_combos
    order = Order.last
    start_date = Date.parse(order.meal_date) + 1
    days = 0
    if order.product.name.include?("Weekly Combo")
      days = 4
      order.update(product_id: assign_new_product_id(start_date - 1))
    elsif order.product.name.include?("Monthly Combo")
      days = 19
      order.update(product_id: assign_new_product_id(start_date - 1))
    end
    days.times do
      Order.create(customer_name: order.customer_name,
                  customer_email: order.customer_email,
                  meal_size: order.meal_size,
                  meal_protein: order.meal_protein,
                  meal_custom: order.meal_custom,
                  notes: order.notes,
                  telephone: order.telephone,
                  delivery_address: order.delivery_address,
                  category: order.category,
                  product_id: assign_new_product_id(start_date),
                  meal_date: start_date.strftime("%d-%m-%Y"))
      start_date += 1
      if start_date.wday == 6
        start_date += 2
      elsif start_date.wday == 0
        start_date += 1
      end
    end
  end

  def assign_new_product_id(date)
    product_name = date.strftime("%A")
    Product.find_by(name: product_name).id
  end
end
