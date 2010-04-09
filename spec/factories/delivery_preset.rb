Factory.define(:delivery_preset) do |f|
  f.day_of_week "mon"
  f.line_items do |line_items| 
    [line_items.association(:line_item), 
    line_items.association(:line_item)]
  end
end
