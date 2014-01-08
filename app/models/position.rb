# == Schema Information
#
# Table name: positions
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  created_at :datetime
#  updated_at :datetime
#  level      :integer
#

class Position < ActiveRecord::Base
  include Seedable
  acts_as_list column: 'level'

  scope :sorted, -> { order :level }

  has_many :users, dependent: :nullify

  VALID_NAME_REGEX = /[a-z ]+/i
  validates :name, presence: true,
                     format: { with: VALID_NAME_REGEX },
                     length: { within: 4..64 },
                 uniqueness: true
end
