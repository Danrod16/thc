class DeliveriesController < ApplicationController
  before_action :set_delivery_category, only: [:index, :show, :edit, :new, :create, :update, :destroy]

  def index
    @delivery_groups = policy_scope(Delivery).where(delivery_category_id: @delivery_category.id)
    @riders = Rider.all
    @rider_orders = []
    @rider = @delivery_category.rider

    if Time.zone.now.strftime("%H").to_i >= "15".to_i
      @total_orders_count = Order.where(meal_date: Date.tomorrow.strftime("%d-%m-%Y"), delivery_category_id: @delivery_category.id)
      @total_orders = @total_orders_count.where(delivery_id: nil)
      @remaining_orders = @total_orders_count.count
    else
      @total_orders_count = Order.where(meal_date: Date.today.strftime("%d-%m-%Y"), delivery_category_id: @delivery_category.id)
      @total_orders = @total_orders_count.where(delivery_id: nil)
      @remaining_orders = @total_orders_count.count
    end
    @total_bowls = @total_orders_count.where(category: "Meals").count
    generate_pdf(@delivery_category, @total_orders)
    set_orders_array
    authorize @delivery_groups
  end

  def show
    @delivery_group = Delivery.find(params[:id])
    @total_delivery_orders = Order.where(delivery_id: @delivery_group).count
    authorize @delivery_group
  end

  def new
    @delivery_category = DeliveryCategory.find(params[:delivery_category_id])
    @delivery_group = Delivery.new
    if Time.zone.now.strftime("%H").to_i >= "15".to_i
      @today_orders = Order.where(meal_date: Date.tomorrow.strftime("%d-%m-%Y"), delivery_id: nil, delivery_category: @delivery_category.id).order(created_at: :asc)
    else
      @today_orders = Order.where(meal_date: Date.today.strftime("%d-%m-%Y"), delivery_id: nil, delivery_category: @delivery_category.id).order(created_at: :asc)
    end
    authorize @delivery_group
  end

  def create
    @delivery_group = Delivery.new(delivery_params)
    @delivery_group.delivery_category_id = @delivery_category.id
    @delivery_group.rider = @delivery_category.rider
    @today_orders = Order.where(meal_date: Date.today.strftime("%d-%m-%Y"), delivery_id: nil)
    if @delivery_group.save
      flash[:alert] = "Grupo creado!"
      redirect_to delivery_category_deliveries_path(@delivery_category.id)
    else
      flash[:alert] = "Error en creación"
      render :new
    end
    authorize @delivery_group
  end

  def edit
    @delivery_group = Delivery.find(params[:id])
    if Time.zone.now.strftime("%H").to_i >= "15".to_i
      without_delivery_group = Order.where(meal_date: Date.tomorrow.strftime("%d-%m-%Y"), delivery_id: nil, delivery_category_id: @delivery_category.id).order(created_at: :asc)
      with_this_delivery_group = Order.where(meal_date: Date.tomorrow.strftime("%d-%m-%Y"), delivery_id: @delivery_group, delivery_category_id: @delivery_category.id)
      @today_orders = with_this_delivery_group + without_delivery_group
    else
      without_delivery_group = Order.where(meal_date: Date.today.strftime("%d-%m-%Y"), delivery_id: nil, delivery_category_id: @delivery_category.id).order(created_at: :asc)
      with_this_delivery_group = Order.where(meal_date: Date.today.strftime("%d-%m-%Y"), delivery_id: @delivery_group, delivery_category_id: @delivery_category.id)
      @today_orders = with_this_delivery_group + without_delivery_group
    end
    authorize @delivery_group
  end

  def update
    @delivery_group = Delivery.find(params[:id])
    @delivery_group.update(delivery_params)
    if @delivery_group.save
      redirect_to delivery_category_deliveries_path(@delivery_category.id)
      flash[:alert] = "Grupo modificado, Gracias #{current_user.first_name}!"
    else
      render :edit
      flash[:alert] = "Error al modificar Grupo!"
    end
    authorize @delivery_group
  end

  def destroy
    @delivery_group = Delivery.find(params[:id])
    remove_delivery_category_id
    if @delivery_group.destroy
      redirect_to delivery_category_deliveries_path(@delivery_category)
    end
    authorize @delivery_group
  end

  private

  def delivery_params
    params.require(:delivery).permit(:name, :rider_id, :delivery_category, :order_ids => [])
  end

  def remove_delivery_category_id
    @delivery_group.orders.each do |order|
      order.update(delivery_category_id: nil) unless order.meal_date.to_date.today?
    end
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

  def set_orders_array
    @total_orders.each do |order|
      @rider_orders << order
    end
    @delivery_groups.each do |group|
      @rider_orders << group
    end
  end

  def set_delivery_category
    @delivery_category = DeliveryCategory.find(params[:delivery_category_id])
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
