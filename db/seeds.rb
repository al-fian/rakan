# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user1 = User.create!(
  first_name: "Jerry",
  last_name: "Superb",
  email: "jerry@example.com",
  username: "jerry432"
)

user2 = User.create!(
  first_name: "Marry",
  last_name: "Sherril",
  email: "smarry@example.com",
  username: "merry432s"
)

Bond.create(user: user1, friend: user2, state: Bond::FOLLOWING)
Bond.create(user: user2, friend: user1, state: Bond::FOLLOWING)

place = Place.create!(
  locale: "en",
  name: "Bangkok Hotel",
  place_type: "hotel",
  coordinate: "POINT (112.73899 -7.2584933 0)"
)

post = Post.create!(user: user1, postable: Status.new(
  text: "Hey all. I'm right here in California now. Anyone wants to meet me?"
))

Post.create!(user: user2, postable: Status.new(
  text: "Great, let's have some fun all."
), thread: post)

Post.create!(user: user1, postable: Status.new(
  text: "How many of us gonna go to the party."
), thread: post)

Post.create!(user: user2, postable: Status.new(
  text: "Count me in. I'll be there soon."
), thread: post)

Post.create!(user: user1, postable: Sight.new(
  place: place, activity_type: Sight::CHECKIN
))