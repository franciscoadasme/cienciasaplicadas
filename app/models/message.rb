class Message
  include ActiveModel::Model

  attr_accessor :subject, :body, :from, :to

  validates :subject, presence: true,
                        length: { within: 4..128 }
  validates :body, presence: true,
                     length: { minimum: 4}

  def deliver
    DefaultMailer.send_message(from, to, subject, body).deliver
  end
end