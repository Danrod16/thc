class DeliveryCategoriesController < ApplicationController
  after_action :check_orders, only: [:update, :destroy]

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
      reorganize(@delivery_category.id, params[:sequence_array])
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
    if @delivery_category.save!
      if (params[:sequence_array])
        reorganize(params[:id], params[:sequence_array])
      end
      render json: { succesful: true, id: params[:id]}
      flash[:alert] = "Reparto modificado, Gracias #{current_user.first_name}!"
    else
      render json: { succesful: false }
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

  def reorganize(id = nil, sequence_array = nil)
    @delivery_category = DeliveryCategory.find(id || params[:delivery_category_id])
    @orders = @delivery_category.orders
    @delivery_groups = policy_scope(Delivery).where(delivery_category_id: @delivery_category)

    orderArray = sequence_array || params[:order_ids]
    orderArray.each_with_index do |id, index|
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

    # # check for groups with same sequence as another order and reorder again
    # require 'pry-byebug'
    # @order_groups = Delivery.where(delivery_category_id: @delivery_category.id)
    # @order_groups.each do |group|
    #   if @orders.where(sequence: group.sequence)
    #     orders_array = @orders.map do |order|
    #       {
    #         id: order.id,
    #         sequence: order.sequence,
    #         type: order.class.to_s
    #       }
    #     end

    #     order_groups_array = @order_groups.map do |group|
    #       {
    #         id: group.id,
    #         sequence: group.sequence,
    #         type: group.class.to_s
    #       }
    #     end
    #     new_sequence_array = orders_array.concat(order_groups_array).sort_by{|object| object[:sequence] }.map do |object|
    #       "#{object[:id]}-#{object[:type]}"
    #     end
    #     # binding.pry
    #     # reorganize(@delivery_category.id, new_sequence_array)
    #   end
    #   break
    # end
    authorize @delivery_category
  end

  private

  def delivery_category_params
    params.require(:delivery_category).permit(:name, :rider_id, :sequence_array, :order_ids => [])
  end

  def check_orders
    Order.where.not(sequence: nil).where(delivery_category: nil).each do |order|
      order.update(sequence: nil)
    end
  end
end
