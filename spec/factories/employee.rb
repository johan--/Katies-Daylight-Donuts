Factory.define(:employee) do |f|
  f.firstname "Tim"
  f.lastname "Matheson"
  f.born_on 21.years.ago
  f.positions{|u|
    [u.association(:position)]
  }
  f.phone "3085551212"
end