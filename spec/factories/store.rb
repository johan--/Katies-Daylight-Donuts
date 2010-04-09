Factory.define(:store) do |f|
  f.name "My Store"
  f.address "110 W. Schuff"
  f.city{ |s| s.association(:city) }
  f.state "NE"
  f.country "USA"
  f.zipcode "68826"
end