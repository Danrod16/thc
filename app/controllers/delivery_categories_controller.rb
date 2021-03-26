class DeliveryCategoriesController < ApplicationController
  after_action :check_orders, only: [:update]

  def new
    @delivery_category = DeliveryCategory.new
     if Time.zone.now.strftime("%H").to_i >= "15".to_i
      @today_orders = Order.where(meal_date: Date.tomorrow.strftime("%d-%m-%Y"), delivery_id: nil, delivery_category_id: nil).order(created_at: :asc)
    else
      @today_orders = Order.where(meal_date: Date.today.strftime("%d-%m-%Y"), delivery_id: nil, delivery_category_id: nil).order(created_at: :asc)
    end
    authorize @delivery_category
  end

  def index
    @delivery_categories = policy_scope(DeliveryCategory).all
    @riders = Rider.all
    if Time.zone.now.strftime("%H").to_i >= "15".to_i
      @remaining_orders = Order.where(meal_date: Date.tomorrow.strftime("%d-%m-%Y"), delivery_id: nil, delivery_category_id: nil).count
    else
      @remaining_orders = Order.where(meal_date: Date.today.strftime("%d-%m-%Y"), delivery_id: nil, delivery_category_id: nil).count
    end

    authorize @delivery_categories
  end

  def create
    @delivery_category = DeliveryCategory.new(delivery_category_params)
    if @delivery_category.save
      # redirect_to new_delivery_category_delivery_path(@delivery_category.id)
      render json: @delivery_category
    else
      flash[:alert] = "Información faltante"
      render :new
    end
    authorize @delivery_category

  end

  def edit
    @delivery_category = DeliveryCategory.find(params[:id])
    if Time.zone.now.strftime("%H").to_i >= "15".to_i
      without_delivery_category = Order.where(meal_date: Date.tomorrow.strftime("%d-%m-%Y"), delivery_id: nil, delivery_category_id: nil).order(created_at: :asc)
      with_this_delivery_category = Order.where(meal_date: Date.tomorrow.strftime("%d-%m-%Y"), delivery_id: nil, delivery_category_id: @delivery_category.id)
      @today_orders = with_this_delivery_category + without_delivery_category
    else
      without_delivery_category = Order.where(meal_date: Date.today.strftime("%d-%m-%Y"), delivery_id: nil, delivery_category_id: nil).order(created_at: :asc)
      with_this_delivery_category = Order.where(meal_date: Date.today.strftime("%d-%m-%Y"), delivery_id: nil, delivery_category_id: @delivery_category.id)
      @today_orders = with_this_delivery_category + without_delivery_category
    end
    authorize @delivery_category
  end

  def update
    @delivery_category = DeliveryCategory.find(params[:id])
    @delivery_category.update(delivery_category_params)
    if @delivery_category.save
      redirect_to delivery_category_deliveries_path(@delivery_category.id)
      flash[:alert] = "Reparto modificado, Gracias #{current_user.first_name}!"
    else
      render :edit
      flash[:alert] = "Error al modificar reparto!"
    end
    authorize @delivery_category
  end

  def destroy
    @delivery_category = DeliveryCategory.find(params[:id])
    if @delivery_category.destroy
      redirect_to delivery_categories_path
    end
    authorize @delivery_category
  end

  def reorganize
    @delivery_category = DeliveryCategory.find(params[:delivery_category_id])
    @orders = @delivery_category.orders
    @delivery_groups = policy_scope(Delivery).where(delivery_category_id: @delivery_category)

    params[:order_ids].each_with_index do |id, index|
      data = id.split('-')
      objectId = data[0]
      objectType = data[1]

      if objectType == 'OrderGroup'
        group = @delivery_groups.find(objectId)
        group.update(sequence: index + 1)
      elsif objectType == 'Order'
        order = @orders.find(objectId)
        order.update(sequence: index + 1)
      end
    end
    authorize @delivery_category

    render json: {
      id: params[:delivery_category_id],
      orders: @orders
    }
  end

  private

  def delivery_category_params
    params.require(:delivery_category).permit(:name, :rider_id, :order_ids => [])
  end

  def check_orders
    Order.where.not(sequence: nil).where(delivery_category: nil).each do |order|
      order.update(sequence: nil)
    end
  end
end
