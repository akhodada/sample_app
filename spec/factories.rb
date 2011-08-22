Factory.define :user do |user|
  user.name	"Alireza"
  user.email	"alirezafcb@yahoo.com"
  user.password	"123456"
  user.password_confirmation	"123456"
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end