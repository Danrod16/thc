class StickersController < ApplicationController
  before_action :set_sticker, only: [:show, :edit, :update, :destroy]
  before_action :selected_orders, only: [:new, :edit]
  def index
    @stickers = Sticker.all
  end

  def show
    @selected_orders = Order.where(meal_date: Date.today.strftime("%d-%m-%Y"), sticker_id: @sticker)
  end

  def new
    @sticker = Sticker.new
  end

  def create
    @sticker = Sticker.new(stickers_params)
    if @sticker.save
      redirect_to stickers_path
      flash[:alert] = "Etiquetas creadas"
    else
      render :new
    end
  end

  def edit
  end

  def update
    @sticker.update(stickers_params)
    redirect_to stickers_path
    flash[:alert] = "Etiquetas actualizadas"
  end

  def destroy
    @sticker.destroy
    redirect_to stickers_path
  end

  private

  def stickers_params
    params.require(:sticker).permit(:order_ids => [])
  end

  def set_sticker
    @sticker = Sticker.find(params[:id])
  end

  def selected_orders
    @selected_orders = Order.where(meal_date: Date.today.strftime("%d-%m-%Y"), printed: false)
  end
end
