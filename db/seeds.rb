# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

4.times do |n|
  email = "example#{sprintf("%003d", n+1)}@example.com"
  password = "12345678"
  user = User.new(email: email,
               password: password,
               password_confirmation: password,
               name: Faker::Name.name,
               uid: SecureRandom.uuid)
  user.skip_confirmation!
  user.save

  3.times do |m|
    Blog.create!(title: Faker::Name.title,
                 content: Faker::Lorem.sentence,
                 user_id: user.id,
                 created_at: Time.now)
  end
end
