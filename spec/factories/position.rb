Factory.sequence(:position_name) do |n|
  "position_name#{n}"
end

Factory.define(:position) do |f|
  f.name{ Factory.next(:position_name) }
end