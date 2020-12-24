# == Schema Information
#
# Table name: statuses
#
#  id         :bigint           not null, primary key
#  text       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Status < ApplicationRecord
end
