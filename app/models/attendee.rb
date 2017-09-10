# == Schema Information
#
# Table name: attendees
#
#  accepted   :boolean
#  created_at :datetime         not null
#  email      :string           not null
#  event_id   :integer
#  id         :integer          not null, primary key
#  locale     :string
#  name       :string
#  updated_at :datetime         not null
#

class Attendee < ActiveRecord::Base
  belongs_to :event
  has_one :abstract, foreign_key: :author_id, dependent: :destroy

  scope :sorted, -> { order :created_at }
  scope :accepted, -> { where accepted: true }

  VALID_NAME_REGEX = /\A[[:alpha:] ,\.'-]+\Z/i
  validates :name, allow_blank: true,
                   format: { with: VALID_NAME_REGEX },
                   length: { in: 3..100 }
  validates :email, presence: true,
                    format: { with: Devise.email_regexp },
                    uniqueness: { scope: :event_id,
                                  case_sensitive: false }

  def self.with_abstract_submitted
    joins(:abstract).where.not abstracts: { submitted_at: nil }
  end

  def display_name
    name.present? ? name : email
  end

  def rejected?
    accepted == false
  end
end
