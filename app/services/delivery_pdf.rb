class DeliveryPdf
  include Prawn::View
  
  def initialize(delivery_group)
    @delivery_group = delivery_group
    @date = set_date
    @hour = Time.now.strftime("%H:%M")
    delivery_summary
  end

  def delivery_summary
    delivery_title
    delivery_rider
    table(delivery_table, :cell_style => { :size => 10 }) do
      row(0).size = 12
      row(0).font_style = :bold
      self.row_colors = ["FFFFFF", "FEFAF1"]
    end
  end

  def delivery_title
    image "thc-logo-1.png", at: [10, 715], width: 120
    bounding_box([435, 700], width: 150, height: 100) do
      text "Reparto", size: 20, style: :bold
      text "#{@date}"  
      text "Hora: #{@hour}"
     end
  end

  def delivery_rider
    text "#{@delivery_group.rider.user.first_name} #{@delivery_group.rider.user.last_name}", size: 14, style: :bold
    move_down 10
  end

  def delivery_table
    arr = []
    @delivery_group.orders.each_with_index do |order, index| 
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