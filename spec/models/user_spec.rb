# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  email      :string           not null
#  first_name :string           not null
#  is_public  :boolean          default(TRUE), not null
#  last_name  :string           not null
#  username   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_users_on_email     (email) UNIQUE
#  index_users_on_username  (username) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  def create_a_user(email: "#{SecureRandom.hex(4)}@gmail.com")
    User.create!(
      first_name: "Adam",
      last_name: "March",
      email: email,
      username: SecureRandom.hex(4),
    )
  end

  describe "#valid?" do
    it "is valid when email is unique" do
      user1 = create_a_user
      user2 = create_a_user

      expect(user2.email).not_to be user1.email
      expect(user2).to be_valid
    end

    it "is invalid if the email is taken" do
      create_a_user(email: "adam33@gmail.com")

      user = User.new
      user.email = "adam33@gmail.com"
      expect(user).not_to be_valid
    end

    it "is invalid if the username is taken" do
      user = create_a_user
      another_user = create_a_user

      expect(another_user).to be_valid
      another_user.username = user.username
      expect(another_user).not_to be_valid
    end

    it "is invalid if user's first name is blank" do
      user = create_a_user
      expect(user).to be_valid

      user.first_name = ""
      expect(user).not_to be_valid

      user.first_name = nil
      expect(user).not_to be_valid
    end

    it "is invalid if the email looks bogus" do
      user = create_a_user
      expect(user).to be_valid

      user.email = ""
      expect(user).to be_invalid

      user.email = "foo.bar"
      expect(user).to be_invalid

      user.email = "foo.bar#example.com"
      expect(user).to be_invalid

      user.email = "f.o.o.b.a.r@example.com"
      expect(user).to be_valid

      user.email = "foo.bar@example.com"
      expect(user).to be_valid

      user.email = "foo.bar@sub.example.co.uk"
      expect(user).to be_valid
    end
  end

  describe "#followings" do
    it "can list all of the user's followings" do
      user = create_a_user
      friend1 = create_a_user
      friend2 = create_a_user
      friend3 = create_a_user

      Bond.create user: user, friend: friend1, state: Bond::FOLLOWING
      Bond.create user: user, friend: friend2, state: Bond::FOLLOWING
      Bond.create user: user, friend: friend3, state: Bond::REQUESTING

      expect(user.followings).to include(friend1, friend2)
      expect(user.follow_requests).to include(friend3)
    end
  end

  describe "#followers" do
    it "can list all of the user's followers" do
      user1 = create_a_user
      user2 = create_a_user
      follower1 = create_a_user
      follower2 = create_a_user
      follower3 = create_a_user
      follower4 = create_a_user

      Bond.create user: follower1, friend: user1, state: Bond::FOLLOWING
      Bond.create user: follower2, friend: user1, state: Bond::FOLLOWING
      Bond.create user: follower3, friend: user2, state: Bond::FOLLOWING
      Bond.create user: follower4, friend: user2, state: Bond::REQUESTING

      expect(user1.followers).to eq([follower1, follower2])
      expect(user2.followers).to eq([follower3])
    end
  end
end
