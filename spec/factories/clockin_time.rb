Factory.define(:clockin_time) do |f|
  f.association(:employee)
  f.starts_at Time.now
end