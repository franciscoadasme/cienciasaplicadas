# == Schema Information
#
# Table name: journals
#
#  id            :integer          not null, primary key
#  name          :string(255)      not null
#  abbr          :string(255)
#  website_url   :string(255)
#  impact_factor :float
#  created_at    :datetime
#  updated_at    :datetime
#

class Journal < ActiveRecord::Base
  has_many :publications

  scope :sorted, -> { order :name }

  auto_strip_attributes :name, :abbr, :website_url
  VALID_NAME_REGEX = /[\w\. -]+/i
  validates :name, presence: true,
                     format: { with: VALID_NAME_REGEX },
                     length: { within: 4..128 },
                 uniqueness: true
  validates :abbr, format: { with: VALID_NAME_REGEX },
                   length: { within: 4..56 },
               uniqueness: true,
              allow_blank: true
  validates :website_url, url: true,
                  allow_blank: true
  validates :impact_factor, numericality: { greater_than: 0 },
                             allow_blank: true
end
