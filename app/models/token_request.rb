class TokenRequest
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks
  extend ActiveModel::Translation

  attr_accessor :attendee_email, :event

  validates :attendee_email, presence: true,
                             format: { with: Devise.email_regexp }
  validate :attendee_is_registered,
           :attendee_is_accepted,
           :can_be_requested

  def attendee
    @attendee ||= Attendee.find_by email: attendee_email
  end

  private

  def attendee_is_accepted
    errors.add(:attendee_email, :not_accepted) unless attendee.try(:accepted?)
  end

  def attendee_is_registered
    errors.add(:attendee_email, :not_registered) if attendee.nil?
  end

  def can_be_requested
    abstract = Abstract.find_by author: attendee, event: event
    errors.add(:attendee_email, :already_submitted) if abstract.try :submitted?
  end
end
