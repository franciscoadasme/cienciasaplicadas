# == Schema Information
#
# Table name: groups
#
#  id               :integer          not null, primary key
#  name             :string(255)
#  abbr             :string(255)
#  logo             :string(255)
#  email            :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  banner_image_url :string(255)
#  tagline          :string(255)
#  address          :text
#

class Group < ActiveRecord::Base
  auto_strip_attributes :name, :abbr, :tagline, :logo, :email, :banner_image_url, :address

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true,
                 uniqueness: { case_sensitive: false }
  validates :abbr, presence: true,
                     length: { within: 3..20 },
                 uniqueness: { case_sensitive: false }
  validates :tagline, length: { within: 10..40 },
                   allow_nil: true
  validates :logo, url: true,
             allow_nil: true
  validates :email, presence: true,
                      format: { with: VALID_EMAIL_REGEX },
                  uniqueness: { case_sensitive: false }
  validates :banner_image_url, url: true,
                         allow_nil: true
  validates :address, length: { within: 10..128 },
                 allow_blank: true

  def display_name
    abbr || name
  end
end
