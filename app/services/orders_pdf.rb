class OrdersPdf
  include Prawn::View
  
  def initialize(meals_summary, snacks_summary, desserts_summary, day)
    @meals_summary = meals_summary
    @snacks_summary = snacks_summary
    @desserts_summary = desserts_summary
    @date = set_date(day)
    @hour = Time.now.strftime("%H:%M")
    orders_summary
  end

  def orders_summary
    order_title
    order_subtitle("Bowls")
    table(bowls_table) do
      row(0).font_style = :bold
      row(1..-1).columns(0).size = 10
      row(1..-1).columns(1..-1).align = :center
      self.row_colors = ["FFFFFF", "FEFAF1"]
    end
    move_down 15
    order_subtitle("Snacks")
    table(snacks_table) do
      row(0).font_style = :bold
      row(1..-1).columns(0).size = 10
      row(1..-1).columns(1..-1).align = :center
      self.row_colors = ["FFFFFF", "FEFAF1"]
    end
    move_down 15
    order_subtitle("Postres")
    # table(desserts_table) do
    #   row(0).font_style = :bold
    #   row(1..-1).columns(0).size = 10
    #   row(1..-1).columns(1..-1).align = :center
    #   self.row_colors = ["FFFFFF", "FEFAF1"]
    # end
  end

  def order_title
    image "thc-logo-1.png", at: [10, 715], width: 120
    bounding_box([435, 700], width: 150, height: 100) do
      text "Cocina", size: 20, style: :bold
      text "#{@date}"  
      text "Hora: #{@hour}"
     end
  end

  def order_subtitle(string)
    text string, size: 14
    move_down 5 
  end

  def bowls_table
    arr = []
    @meals_summary.each do |e| 
      e[0] = e.first.capitalize
      arr << e
    end
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

