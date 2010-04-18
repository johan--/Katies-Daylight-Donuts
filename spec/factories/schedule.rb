Factory.define(:schedule) do |f|
  f.employee_id{|u| u.association(:employee) }
  f.starts_at Time.zone.now
  f.ends_at (Time.zone.now+2.hours)
end