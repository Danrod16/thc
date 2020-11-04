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
    bounding_box([6,190], width: 270, height: 190) do
      # stroke_bounds
      bounding_box([0,190], width: 270, height: 100) do
        move_down 10
        image "thc-logo-1.png", width: 120
        move_down 10
        draw_text(order.product.meal_name, :at => [125, 80], :style => :bold, :size => 10)
        bounding_box([125, 75], width: 140, height: 30) do
          if order.product.description.include?("Allergies")
            allergies = order.product.description.split("Allergies:").last.strip
            font_size(7)
            text "(Allergies: #{allergies})"
            # stroke_bounds
          end
        end
        bounding_box([125, 50], width: 140, height: 140) do
          font_size(8)
          text order.customer_name
          text order.delivery_address
          text order.telephone
          text "Size: #{order.meal_size}"
          text "Protein: #{order.meal_protein}"
          text "Customization: #{order.meal_custom}"
          # text "Notes: #{order.notes}"
          # stroke_bounds
        end
        # stroke_bounds
      end
      bounding_box([0, 108], width: 270, height: 100) do
        image "thc-QRCode.png", width: 85
        draw_text("Scan me for more info", :at => [5, 12], :style => :bold, :size => 6)
        draw_text("about calories and macros", :at => [5, 6], :style => :bold, :size => 6)
        bounding_box([108, 45], width: 170, height: 50) do
          font_size(8)
          text "INSTRUCTIONS:", style: :bold
          move_down 5
          text "1. Mix all the ingredients"
          text "2. Heat directly in the microwave (omit if salad)"
          text "3. Enjoy it!"
          # stroke_bounds
        end
      end
      # stroke_bounds
    end
  end
end


