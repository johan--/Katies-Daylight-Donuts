# Black and White colors
stripes = ["EBEBEB","FFFFFF"]

@deliveries.each_with_index do |delivery, index|
  # Only generate an invoice if the delivery has items, this is simply
  # prevent any bad data from generating a form. 
  
  unless delivery.line_items.empty?
  render :partial => "shared/delivery_pdf", :object => delivery, :format => :pdf
  pdf.start_new_page unless (index+1) == @deliveries.size
  end
end