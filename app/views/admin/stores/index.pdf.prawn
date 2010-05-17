# Black and White colors
stripes = ["EBEBEB","FFFFFF"]



Route.find(:all, :include => [:stores]).map do |route|
  data = []
  data << [{:text => route.name, :colspan => 2}]
  route.stores.sort_by(&:position).map do |store|
    data << [store.id,store.name]
  end  
  pdf.table data, :width => 500, :border_style => :grid, :row_colors => stripes, :headers => ["Store ID", "Store Name"]
  pdf.start_new_page
end
