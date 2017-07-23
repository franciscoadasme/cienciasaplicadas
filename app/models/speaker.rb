class Speaker < ActiveRecord::Base
  belongs_to :event
  has_attached_file :photo, styles: { thumb: '128x128#' }

  scope :sorted, -> { order name: :asc }

  VALID_NAME_REGEX = /\A[[:alpha:] ,\.'-]+\Z/i
  validates :name, presence: true,
                   format: { with: VALID_NAME_REGEX },
                   length: { in: 3..120 },
                   uniqueness: { scope: :event }
  validates :description, presence: true
  validates :institution, presence: true
  validates :website_url, allow_blank: true,
                          url: true
  validates_attachment :photo, allow_blank: true,
                               content_type: {
                                 content_type: ['image/jpg', 'image/jpeg', 'image/gif', 'image/png'],
                                 message: I18n.t('activerecord.errors.models.speaker.attributes.photo.spoofed_media_type')
                               },
                               size: { in: 0..5.megabytes }
end
