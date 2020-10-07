class OrdersPdf < Prawn::Document
  def initialize(meals_summary, snacks_summary, desserts_summary, day)
    super()
    @meals_summary = meals_summary
    @snacks_summary = snacks_summary
    @desserts_summary = desserts_summary
    @date = set_date(day)
    @hour = Time.now.strftime("%H:%M")
    order_summary
  end

  def order_summary
    order_header
    text "Bowls", size: 15
    move_down 5 
    table bowls_table
    move_down 20
    text "Snacks", size: 15
    move_down 5
    table snacks_table
    move_down 20
    text "Postres", size: 15
    table desserts_table
  end

  def order_header
    text "Cocina", size: 20, style: :bold
    text "Fecha: #{@date}"  
    text "Hora: #{@hour}"
    move_down 20
  end

  def bowls_table
    arr = []
    @meals_summary.each { |e| arr << e }
    [["Nombre", "Normal", "Low Carb", "High Carb", "High Protein", "Keto", "High Protein/Low Carb"]] + arr
  end

  def snacks_table
    arr = []
    @snacks_summary.each { |e| arr << e }
    [["Nombre", "Cantidad"]] + arr
  end

  def desserts_table
    arr = []
    @desserts_summary.each { |e| arr << e }
    [["Nombre", "Cantidad"]] + arr
  end

  def set_date(day)
    day = Date.parse(day)
    week = { "monday" => "Lunes", "tuesday" => "Martes", "wednesday" => "Miercoles", "thursday" => "Jueves", "friday" => "Viernes" }
    "#{week[day.strftime("%A").downcase]} #{day.strftime("%d-%m-%y")}"
  end
end

