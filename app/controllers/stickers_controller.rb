class StickersController < ApplicationController
  before_action :set_sticker, only: [:show, :edit, :update, :destroy]
  before_action :selected_orders, only: [:new, :edit]

  def index
    @stickers = policy_scope(Sticker).all
    @remaining_orders = Order.where(meal_date: Date.today.strftime("%d-%m-%Y"), sticker_id: nil).count
    authorize @stickers
  end

  def show
    @selected_orders = Order.where(meal_date: Date.today.strftime("%d-%m-%Y"), sticker_id: @sticker)
    generate_pdf(@selected_orders)
    authorize @sticker
  end

  def new
    @sticker = Sticker.new
    @selected_orders = Order.where(meal_date: Date.today.strftime("%d-%m-%Y"), sticker_id: nil)
    authorize @sticker
  end

  def create
    @sticker = Sticker.new(stickers_params)
    if @sticker.save
      redirect_to stickers_path
      flash[:success] = "Etiquetas creadas"
    else
      render :new
    end
    authorize @sticker
  end

  def edit
    authorize @sticker
  end

  def update
    @sticker.update(stickers_params)
    redirect_to stickers_path
    flash[:success] = "Etiquetas actualizadas"
    authorize @sticker
  end

  def destroy
    @sticker.destroy
    redirect_to stickers_path
    authorize @sticker
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

  def generate_pdf(selected_orders)
    respond_to do |format|
      format.html
      format.pdf do
        pdf = StickerPdf.new(selected_orders)
        send_data pdf.render, filename:"etiquetas.pdf",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end
end
