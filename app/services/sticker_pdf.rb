class StickerPdf
  include Prawn::View
  
  def initialize(selected_orders)
    @selected_orders = selected_orders
    create_stickers
  end

  def create_stickers
    define_grid columns: 2, rows: 4, gutter: 10
    col = 0
    row = 0
    @selected_orders.each do |order|
      grid(row,col).bounding_box do
        sticker(order)
        if row == 3 && col == 1
          start_new_page
          define_grid columns: 2, rows: 4, gutter: 10
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
    end
  end

  def sticker(order)
    image "thc-logo-1.png", width: 70
    draw_text(order.product.meal_name, :at => [80, 165], :style => :bold, :size => 8)
    text_box(order.product.description, :at => [80, 155], :size => 8)  
    font_size(8)
    bounding_box([0, 100], width: 100, height: 100) do
      text order.customer_name
      text order.delivery_address  
      text "Talla: #{order.meal_size}"
      text "Proteína: #{order.meal_protein}"
      text "Customización: #{order.meal_custom}"
     end
     bounding_box([120, 100], width: 180, height: 150) do
      text "Notas: #{order.notes}"
     end
  end
end

