Factory.sequence(:city_name) do |n|
  "City Name #{n}"
end

Factory.define(:city) do |f|
  f.name{ Factory.next(:city_name) }
end