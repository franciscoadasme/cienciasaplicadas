# Non-persistent model used for announcements
class Message
  include ActiveModel::Model

  attr_accessor :subject, :body

  validates :subject, presence: true, length: { within: 4..128 }
  validates :body, presence: true, length: { minimum: 10 }
end
