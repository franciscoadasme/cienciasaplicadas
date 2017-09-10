class Attendee < ActiveRecord::Base
  belongs_to :event
  has_one :abstract, dependent: :destroy

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

  def display_name
    name
  end

  def rejected?
    accepted == false
  end
end
