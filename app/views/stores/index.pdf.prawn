# Black and White colors
stripes = ["EBEBEB","FFFFFF"]

data = []

@stores.group_by{|s| s.route }.map do |route, stores|
  pdf.text route.name, :size => 20
  
  data << [{:text => route.name, :colspan => 2}]
  stores.sort_by{|s| s.position }.map do |store|
    data << [store.id,store.name]
  end
  pdf.table data, :width => 500, :border_style => :grid, :row_colors => stripes, :headers => ["Store ID", "Store Name"]
  pdf.start_new_page
end