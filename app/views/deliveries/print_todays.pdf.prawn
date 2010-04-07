stripes = ["ACACAC","FFFFFF"]
pdf.font "Helvetica"

@deliveries.each_with_index do |delivery, index|
  unless delivery.line_items.empty?
  pdf.image("#{RAILS_ROOT}" + "/public/images/logo-small.png")
  
  pdf.table [
    [{:text => "Invoice", :colspan => 5, :align => :center, :background_color => "ACACAC"}],
    [{:text => "Katies Daylight Donuts \n1501 18TH ST.\nCentral City, NE\nUSA 68826\n\nPhone: 308-946-5555", :align => :left},
     {:text => "Invoice #: #{delivery.id}\nDate : #{Time.zone.now.strftime('%m/%d/%Y')}\nE-Mail :#{delivery.email}", :rowspan => 2, :colspan => 3}],
    [{:text => "Customer Sold to: \n#{delivery.address}"},
     {:text => "Ship to: \n#{delivery.address}"}]
  ], :width => 500

  items = delivery.line_items.map{ |line_item|
    [
      line_item.item.id,
      line_item.item.name,
      line_item.quantity,
      number_to_currency(line_item.item.price),
      {:text => number_to_currency(line_item.total), :align => :right}
    ]
  }
  
  items << [
    {:text => "Total: ", :align => :left, :colspan => 1},
    {:text => number_to_currency(delivery.total), :align => :right, :colspan => 4}
  ]
    
  pdf.table items, :border_style => :grid, 
            :row_colors => stripes,
            :headers => ["Product Code", "Description", "Quantity", "Price", "Extension"],
            :width => 500
  pdf.start_new_page unless (index+1) == @deliveries.size
  end
end