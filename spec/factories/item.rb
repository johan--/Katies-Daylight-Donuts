Factory.sequence :item_name do |n|
  "Donut#{n}"
end

Factory.define(:item) do |f|
  f.name{ Factory.next(:item_name) }
  f.item_type "roll"
  f.price 0.35
end