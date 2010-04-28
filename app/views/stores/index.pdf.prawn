# Black and White colors
stripes = ["EBEBEB","FFFFFF"]

data = []

Route.find(:all, :include => [:stores]).map do |route|
  pdf.text route.name, :size => 20
  route.stores.sort_by{|s| s.position }.map do |store|
    data << [store.id,store.name]
  end
  pdf.table data, :width => 500, :border_style => :grid, :row_colors => stripes, :headers => ["Store ID", "Store Name"]
  pdf.start_new_page
end