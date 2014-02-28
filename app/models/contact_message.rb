class ContactMessage
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks

  before_validation :format_as_student

  attr_accessor :first_name, :last_name, :email, :body, :as_student

  VALID_NAME_REGEX = /\A[[:alpha:] ,\.'-]+\Z/i
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :first_name, presence: true,
                           format: { with: VALID_NAME_REGEX },
                           length: { within: 4..128 }
  validates :last_name, presence: true,
                          format: { with: VALID_NAME_REGEX },
                          length: { within: 4..128 }
  validates :email, presence: true,
                      format: { with: VALID_EMAIL_REGEX },
                      length: { in: 4..60 }
  validates :body, presence: true,
                     length: { minimum: 4}

  def sender
    "#{first_name} #{last_name}"
  end

  def deliver!
    DefaultMailer.send_contact_message(self).deliver
  end

  private
    def format_as_student
      self.as_student = as_student == '1'
      true
    end
end