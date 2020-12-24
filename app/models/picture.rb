# == Schema Information
#
# Table name: pictures
#
#  id         :bigint           not null, primary key
#  caption    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :bigint
#
class Picture < ApplicationRecord
end
