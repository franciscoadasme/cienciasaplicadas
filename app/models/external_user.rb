# == Schema Information
#
# Table name: external_users
#
#  id          :integer          not null, primary key
#  first_name  :string(255)      not null
#  last_name   :string(255)      not null
#  institution :string(255)      not null
#  city        :string(255)      not null
#  country     :string(255)      not null
#  website_url :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class ExternalUser < ActiveRecord::Base
  has_and_belongs_to_many :projects

  default_scope -> { order :first_name, :last_name  }

  validates :first_name, presence: true,
                           format: { with: User::VALID_NAME_REGEX },
                           length: { in: 3..20 }
  validates :last_name, presence: true,
                          format: { with: User::VALID_NAME_REGEX },
                          length: { in: 3..40 }
  validates :website_url, url: true,
                  allow_blank: true

  def display_name
    full_name
  end

  def external?
    true
  end

  def full_name
    "#{first_name.split.first} #{last_name}" rescue nil
  end
end
