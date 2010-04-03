Factory.define(:store) do |f|
  f.name "My Store"
  f.city{ |s| s.association(:city) }
  f.state "NE"
  f.country "USA"
  f.zipcode "68826"
end