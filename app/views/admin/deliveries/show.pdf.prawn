# Black and White colors
stripes = ["EBEBEB","FFFFFF"]

# Add Logo
pdf.image("#{RAILS_ROOT}" + "/public/images/logo-small.png")

# Add Headers
invoice_date = (@delivery.delivery_date+1.day).strftime('%m/%d/%Y')
pdf.table [
  [{:text => "Invoice #{invoice_date}", :colspan => 5, :align => :center, :background_color => "ACACAC"}],
  [{:text => "#{@setting.name} \n#{@setting.address}\n#{@setting.city}, #{@setting.state}\n#{@setting.country} #{@setting.zipcode}\n\nPhone: #{@setting.phone}", :align => :left},
   {:text => "Invoice #: #{@delivery.id}\nDate : #{invoice_date}\nE-Mail :#{@delivery.email}", :rowspan => 2, :colspan => 3}],
  [{:text => "Customer Sold to: \n#{@delivery.address.upcase}"},
   {:text => "Ship to: \n#{@delivery.address.upcase}"}]
], :width => 500

# Add Line Items
data = @delivery.line_items.select{|li| li if li.quantity.to_i > 0 }.map{ |line_item|
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

# Add the store notes to the Invoice
data << [
  {:text => "Store Notes: ", :align => :left, :colspan => 1},
  {:text => @delivery.store.notes, :colspan => 3}
] unless @delivery.store.notes.nil?

#   
pdf.table data, :border_style => :grid, 
          :row_colors => stripes,
          :headers => ["Description", "Quantity", "Price", "Extension"],
          :width => 500

pdf.start_new_page

# Counts
pdf.text "Counts", :size => 18
pdf.text "Date: #{Time.zone.now.strftime('%b %d, %Y')}"
pdf.text "Roll Count #{@roll_count}"
pdf.text "Donut Count #{@donut_count}"
pdf.text "Donut Hole Count #{@donut_hole_count}"

