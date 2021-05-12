class StickersController < ApplicationController
  before_action :set_sticker, only: [:show, :edit, :update, :destroy]
  before_action :selected_orders, only: [:new, :show]
  before_action :edit_selected_orders, only: [:edit]

  def index
    @stickers = policy_scope(Sticker).all
    @remaining_orders = Order.where(meal_date: Date.today.strftime("%d-%m-%Y"), sticker_id: nil, category: "Meals").count
    authorize @stickers
  end

  def show
    generate_pdf(@selected_orders)
    authorize @sticker
  end

  def new
    @sticker = Sticker.new
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
    if Time.zone.now.strftime("%H").to_i >= "15".to_i
      @selected_orders = Order.where(meal_date: Date.tomorrow.strftime("%d-%m-%Y"), sticker_id: @sticker, category: "Meals").order(created_at: :asc)
    else
      @selected_orders = Order.where(meal_date: Date.today.strftime("%d-%m-%Y"), sticker_id: @sticker, category: "Meals").order(created_at: :asc)
    end
  end

  def edit_selected_orders
    if Time.zone.now.strftime("%H").to_i >= "15".to_i
      without_stickers = Order.where(meal_date: Date.tomorrow.strftime("%d-%m-%Y"), sticker_id: nil, category: "Meals").order(created_at: :asc)
      with_this_sticker = Order.where(meal_date: Date.tomorrow.strftime("%d-%m-%Y"), sticker_id: @sticker, category: "Meals")
    else
      without_stickers = Order.where(meal_date: Date.today.strftime("%d-%m-%Y"), sticker_id: nil, category: "Meals").order(created_at: :asc)
      with_this_sticker = Order.where(meal_date: Date.today.strftime("%d-%m-%Y"), sticker_id: @sticker, category: "Meals")
    end
    @selected_orders = with_this_sticker + without_stickers
  end

  def generate_pdf(selected_orders)
    respond_to do |format|
      format.html
      format.pdf do
        pdf = StickerPdf.new(selected_orders)
        pdf.delete_page(0)
        send_data pdf.render, filename: "etiquetas.pdf",
                              type: "application/pdf"
      end
    end
  end
end
