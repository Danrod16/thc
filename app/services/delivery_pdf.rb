class DeliveryPdf
  require 'prawn'
  include Prawn::View

  def initialize(delivery_group, total_delivery_orders)
    @delivery_group = delivery_group
    @total_delivery_orders = total_delivery_orders
    @date = set_date
    @hour = Time.zone.now.strftime("%H:%M")
    font("ArialUnicode.ttf")
    delivery_summary
  end

  def delivery_summary
    delivery_title
    delivery_rider
    table(delivery_data, :column_widths => [30,120,100,150,140], :cell_style => { :size => 10 }) do
      row(0).size = 12
      # row(0).font_style = :bold
      row(1..-1).columns(0).align = :center
      row(1..-1).columns(0..-1).valign = :center
      self.row_colors = ["FFFFFF", "FEFAF1"]
    end
  end

  def delivery_title
    image "thc-logo-1.png", at: [10, 715], width: 120
    bounding_box([435, 700], width: 150, height: 100) do
      text "Reparto", size: 20
      text "#{@date}"
      text "Hora: #{@hour}"
     end
  end

  def delivery_rider
    text "#{@delivery_group.rider.user.first_name} #{@delivery_group.rider.user.last_name}", size: 14
    move_down 10
    text "Total de pedidos: #{@total_delivery_orders}"
    move_down 10
  end

  def delivery_data
    arr = []
    @delivery_group.orders.order(:sequence).each_with_index do |order, index|
      arr << [index + 1, order.customer_name, order.telephone, order.delivery_address, order.notes]
    end
    [["" ,"Nombre", "Teléfono", "Dirección", "Notas"]] + arr
  end

  def set_date
    day = Time.now
    week = { "monday" => "Lunes", "tuesday" => "Martes", "wednesday" => "Miercoles", "thursday" => "Jueves", "friday" => "Viernes" }
    "#{week[day.strftime("%A").downcase]} #{day.strftime("%d-%m-%y")}"
  end
end
