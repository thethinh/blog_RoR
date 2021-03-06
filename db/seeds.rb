# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# User.create!(name:  "Example User",
#     email: "example@railstutorial.org",
#     password:              "foobar",
#     password_confirmation: "foobar")

# 99.times do |n|
# name  = Faker::Name.name
# email = "example-#{n+1}@railstutorial.org"
# password = "password"
# User.create!(name:  name,
#       email: email,
#       password:              password,
#       password_confirmation: password)
# end
User.create!(name: 'Example User',
             email: 'example@railstutorial.org',
             password: 'foobar',
             password_confirmation: 'foobar',
             activated: true,
             activated_at: Time.zone.now)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n + 1}@railstutorial.org"
  password = 'password'
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: content) }
end

# comment for first post of first user
users = User.all
post = users.first.microposts.first
usercmt = users[2..10]
usercmt.each do |usercmt|
  usercmt.comment.create!(
    micropost_id: post.id,
    body: 'Hello everyone !'
  )
end

# reactions for micropost
micropost = Micropost.first
users = User.take(20)
users.each do |uid|
  micropost.reaction.create(user_id: uid.id, reactions: 'Like')
end
