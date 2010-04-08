# Black and White colors
stripes = ["EBEBEB","FFFFFF"]

# Add Logo
pdf.image("#{RAILS_ROOT}" + "/public/images/logo-small.png")

# Add Headers
pdf.table [
  [{:text => "Invoice #{@delivery.created_at.strftime('%m/%d/%Y')}", :colspan => 5, :align => :center, :background_color => "ACACAC"}],
  [{:text => "Katies Daylight Donuts \n1501 18TH ST.\nCentral City, NE\nUSA 68826\n\nPhone: 308-946-5555", :align => :left},
   {:text => "Invoice #: #{@delivery.id}\nDate : #{Time.zone.now.strftime('%m/%d/%Y')}\nE-Mail :#{@delivery.email}", :rowspan => 2, :colspan => 3}],
  [{:text => "Customer Sold to: \n#{@delivery.address}"},
   {:text => "Ship to: \n#{@delivery.address}"}]
], :width => 500

# Add Line Items
data = @delivery.line_items.map{ |line_item|
  [
    line_item.item.name,
    line_item.quantity,
    {:text => number_to_currency(line_item.item.price), :align => :right},
    {:text => number_to_currency(line_item.total), :align => :right}
  ]
}

# Add Invoice Total
data << [
  {:text => "Total: ", :align => :left, :colspan => 1},
  {:text => number_to_currency(@delivery.total), :align => :right, :colspan => 3}
]

# Add the notes to the Invoice
data << [
  {:text => "Notes: ", :align => :left, :colspan => 1},
  {:text => @delivery.comments.map(&:body).join("\n"), :colspan => 3}
]

#   
pdf.table data, :border_style => :grid, 
          :row_colors => stripes,
          :headers => ["Description", "Quantity", "Price", "Extension"],
          :width => 500