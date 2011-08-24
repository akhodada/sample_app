Factory.define :user do |user|
  user.name	"Annamae Turcotte"
  user.email	"example-99@railstutorial.org"
  user.password	"password"
  user.password_confirmation	"password"
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

Factory.define :micropost do |micropost|
 micropost.content "Foo bar"
 micropost.association :user
end