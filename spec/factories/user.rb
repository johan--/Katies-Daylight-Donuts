Factory.define(:user) do |f|
  f.username "Tim Matheson"
  f.password "password"
  f.password_confirmation "password"
  f.email "me@timmatheson.com"
end