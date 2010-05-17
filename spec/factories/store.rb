Factory.sequence(:position) do |n|
  "#{n}"
end

Factory.sequence(:store_name) do |n|
  "Store #{n}"
end

Factory.define(:store) do |f|
  f.name{ Factory.next(:store_name) }
  f.address "110 W. Schuff"
  f.city{ |s| s.association(:city) }
  f.state "NE"
  f.country "USA"
  f.zipcode "68826"
  f.position 0
end