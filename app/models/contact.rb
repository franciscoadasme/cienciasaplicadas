# == Schema Information
#
# Table name: contacts
#
#  id          :integer          not null, primary key
#  first_name  :string(255)      not null
#  last_name   :string(255)      not null
#  institution :string(255)
#  email       :string(255)      not null
#  website_url :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Contact < ActiveRecord::Base
  scope :sorted, -> { order :last_name, :first_name }

  auto_strip_attributes :first_name, :last_name, :institution, :website_url
  VALID_NAME_REGEX = /\A[[:alpha:] ,\.'-]+\Z/i
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :first_name, presence: true,
                           format: { with: VALID_NAME_REGEX },
                           length: { within: 3..20 },
                       uniqueness: { scope: :last_name }
  validates :last_name, presence: true,
                          format: { with: VALID_NAME_REGEX },
                          length: { within: 3..20 }
  validates :email, presence: true,
                      format: { with: VALID_EMAIL_REGEX },
                  uniqueness: true,
                   exclusion: { within: -> c { User.pluck(:email) },
                               message: 'An existing user has this email address'}
  validates :institution, format: { with: VALID_NAME_REGEX },
                          length: { within: 3..128},
                     allow_blank: true
  validates :website_url, url: true,
                  allow_blank: true

  def display_name
    "#{first_name} #{last_name}"
  end

  def image_url
  end

  def mailing_lists
    @mailing_lists ||= MailingList.with_address email
  end
end
