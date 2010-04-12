Factory.define(:delivery) do |f|
  f.store{|u| u.association(:store) } 
  f.employee{|u| u.association(:employee) }
  f.delivery_date Time.now
end