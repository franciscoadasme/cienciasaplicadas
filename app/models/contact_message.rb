class ContactMessage
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks

  before_validation :format_as_student

  attr_accessor :sender_name, :sender_email, :body, :as_student

  VALID_NAME_REGEX = /\A[[:alpha:] ,\.'-]+\Z/i
  validates :sender_name, presence: true,
                          format: { with: VALID_NAME_REGEX },
                          length: { within: 4..128 }
  validates :sender_email, presence: true,
                           format: { with: Devise.email_regexp },
                           length: { in: 4..60 }
  validates :body, presence: true,
                   length: { minimum: 10 }

  def sended_by_student?
    as_student
  end

  private

  def format_as_student
    self.as_student = as_student == '1'
    true
  end
end
