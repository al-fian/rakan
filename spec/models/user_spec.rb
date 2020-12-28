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
  end
end
