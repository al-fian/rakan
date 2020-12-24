# == Schema Information
#
# Table name: places
#
#  id         :bigint           not null, primary key
#  coordinate :geometry         point, 0
#  locale     :string
#  name       :string
#  place_type :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :place do
    locale { "MyString" }
    coordinate { "" }
    name { "MyString" }
    place_type { "MyString" }
  end
end
