Factory.sequence(:email) do |n|
  "example@#{n}example.com"
end

Factory.sequence(:username) do |n|
  "joe#{n}user"
end

Factory.define(:user) do |f|
  f.username{Factory.next(:username)}
  f.password "password"
  f.password_confirmation "password"
  f.email{Factory.next(:email)}
end