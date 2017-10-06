# == Schema Information
#
# Table name: abstracts
#
#  author_id             :integer
#  created_at            :datetime
#  document_content_type :string
#  document_file_name    :string
#  document_file_size    :integer
#  document_updated_at   :datetime
#  event_id              :integer
#  id                    :integer          not null, primary key
#  submitted_at          :string
#  title                 :string(255)
#  token                 :string
#  token_created_at      :datetime
#  updated_at            :datetime
#

class Abstract < ActiveRecord::Base
  belongs_to :author, class_name: 'Attendee'
  belongs_to :event
  has_attached_file :document, path: ':document_s3_path'

  Paperclip.interpolates(:document_s3_path) do |attachment, _|
    attachment.instance.send :document_s3_path
  end

  scope :submitted, -> { where.not submitted_at: nil }

  TOKEN_LIFETIME_IN_SECONDS = 48.hours
  ACCEPTED_CONTENT_TYPES = [
    'application/pdf',
    'application/msword',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
  ].freeze

  validates :title, presence: true
  validates :author, uniqueness: { scope: :event }
  validates_attachment :document,
                       presence: true,
                       content_type: { content_type: ACCEPTED_CONTENT_TYPES },
                       size: { less_than: 2.megabytes }

  def randomize_token!
    self.token = SecureRandom.hex 16
    self.token_created_at = DateTime.now
  end

  def reset_token!
    self.token = nil
    self.token_created_at = nil
  end

  def submitted?
    !submitted_at.nil?
  end

  def token_expired?
    token_created_at.advance(seconds: TOKEN_LIFETIME_IN_SECONDS) < DateTime.now
  end

  private

  def document_s3_path
    custom_id = format '%03i', id
    author_name = author.name.parameterize.underscore.camelcase
    extension = Paperclip::Interpolations.extension document, nil
    "events/#{event.id}/abstracts/#{author_name}.#{custom_id}.#{extension}"
  end
end
