class StickerPdf
  include Prawn::View
  
  def initialize(selected_orders)
    @selected_orders = selected_orders
    create_stickers
  end

  def create_stickers
    start_new_page(margin: [10, 30, 10, 30])
    define_grid columns: 2, rows: 4, column_gutter: 5
    
    # grid.show_all
    # stroke_bounds
    
    col = 0
    row = 0
    @selected_orders.each do |order|
      grid(row,col).bounding_box do
        sticker(order)
        if row == 3 && col == 1
          start_new_page(margin: [10, 30, 10, 30])
          define_grid columns: 2, rows: 4, column_gutter: 5
          col = 0
          row = 0
        else 
          if col == 1
            row += 1
            col = 0
          else
            col += 1
          end
        end
      end
      # stroke_bounds
    end
  end

  def sticker(order)
    bounding_box([10,190], width: 270, height: 190) do
      # stroke_bounds
      bounding_box([0,190], width: 270, height: 100) do
        move_down 10
        image "thc-logo-1.png", width: 130
        move_down 10
        draw_text(order.product.meal_name, :at => [135, 80], :style => :bold, :size => 10)
        bounding_box([135, 70], width: 125, height: 120) do
          font_size(8)
          text order.customer_name  
          text "Talla: #{order.meal_size}"
          text "Proteína: #{order.meal_protein}"
          text "Customización: #{order.meal_custom}"
          text "Notas: #{order.notes}"
          # stroke_bounds
        end
        # stroke_bounds
      end 
        # subir el QRCode 
      bounding_box([0, 95], width: 270, height: 100) do
      image "thc-QRCode.png", width: 90
      # bounding_box([108, 95], width: 140, height: 50) do
      #   # stroke_bounds
      # end
      # stroke_bounds
      end
    end
  end
end

