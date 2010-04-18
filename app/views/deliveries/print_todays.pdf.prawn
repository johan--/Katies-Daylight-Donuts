# Black and White colors
stripes = ["EBEBEB","FFFFFF"]

# Counts
pdf.text "Counts", :size => 18
pdf.text "Date: #{Time.zone.now.strftime('%b %d, %Y')}"
pdf.text "Roll Count #{@roll_count}"
pdf.text "Donut Count #{@donut_count}"
pdf.text "Donut Hole Count #{@donut_hole_count}"
pdf.start_new_page

# Work Schedule
schedule_data = Schedule.for_today.map do |schedule|
  [{:text => schedule.employee.fullname},{:text => "#{schedule.starts} - #{schedule.ends} Total: #{pluralize(schedule.total_hours,'Hour')}"}]
end

pdf.text "Schedule", :size => 18
pdf.text "Date: #{Time.zone.now.strftime('%b %d, %Y')}"
pdf.table schedule_data, :headers => ["Employee","Hours"]
pdf.start_new_page

# Start deliveries
@deliveries.each_with_index do |delivery, index|
  # Only generate an invoice if the delivery has items, this is simply
  # prevent any bad data from generating a form. 
  
  unless delivery.line_items.empty?
    # Add Logo
    pdf.image("#{RAILS_ROOT}" + "/public/images/logo-small.png")

    # Add Headers
    pdf.table [
      [{:text => "Invoice #{(delivery.delivery_date+1.day).strftime('%m/%d/%Y')}", :colspan => 5, :align => :center, :background_color => "ACACAC"}],
      [{:text => "Katies Daylight Donuts \n1501 18TH ST.\nCentral City, NE\nUSA 68826\n\nPhone: 308-946-5555", :align => :left},
       {:text => "Invoice #: #{delivery.id}\nDate : #{(delivery.delivery_date+1.day).strftime('%m/%d/%Y')}\nE-Mail :#{delivery.email}", :rowspan => 2, :colspan => 3}],
      [{:text => "Customer Sold to: \n#{delivery.address.upcase}"},
       {:text => "Ship to: \n#{delivery.address.upcase}"}]
    ], :width => 500

    # Add Line Items
    data = delivery.line_items.select{|li| li if li.quantity.to_i > 0 }.map{ |line_item|
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
      {:text => number_to_currency(delivery.total), :align => :right, :colspan => 3}
    ]

    # Add the notes to the Invoice
    data << [
      {:text => "Notes: ", :align => :left, :colspan => 1},
      {:text => delivery.comments.map(&:body).join("\n"), :colspan => 3}
    ]

    #   
    pdf.table data, :border_style => :grid, 
              :row_colors => stripes,
              :headers => ["Description", "Quantity", "Price", "Extension"],
              :width => 500
  pdf.start_new_page unless (index+1) == @deliveries.size
  end
end