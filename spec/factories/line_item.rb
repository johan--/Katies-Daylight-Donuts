Factory.define(:line_item) do |f|
  f.item{|l| l.association(:item) }
  f.quantity 12
  f.price 0.35
end