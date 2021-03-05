class DeliveryCategoriesController < ApplicationController
  def new
    @delivery_category = DeliveryCategory.new
     if Time.zone.now.strftime("%H").to_i >= "15".to_i
      @today_orders = Order.where(meal_date: Date.tomorrow.strftime("%d-%m-%Y"), delivery_id: nil).order(created_at: :asc)
    else
      @today_orders = Order.where(meal_date: Date.today.strftime("%d-%m-%Y"), delivery_id: nil).order(created_at: :asc)
    end
    authorize @delivery_category
  end

  def index
    @delivery_categories = policy_scope(DeliveryCategory).all
    @riders = Rider.all
    if Time.zone.now.strftime("%H").to_i >= "15".to_i
      @remaining_orders = Order.where(meal_date: Date.tomorrow.strftime("%d-%m-%Y"), delivery_id: nil).count
    else
      @remaining_orders = Order.where(meal_date: Date.today.strftime("%d-%m-%Y"), delivery_id: nil).count
    end
    authorize @delivery_categories
  end

  def create
    @delivery_category = DeliveryCategory.new(delivery_category_params)
    if @delivery_category.save
      redirect_to new_delivery_category_delivery_path(@delivery_category.id)
    end
    authorize @delivery_category
  end

  def update
  end

  def destroy
    @delivery_category = DeliveryCategory.find(params[:id])
    if @delivery_category.destroy
      redirect_to delivery_categories_path
    end
    authorize @delivery_category
  end

  private

  def delivery_category_params
    params.require(:delivery_category).permit(:name, :rider_id, :order_ids => [])
  end
end
