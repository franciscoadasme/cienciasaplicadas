# == Schema Information
#
# Table name: moments
#
#  id                 :integer          not null, primary key
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  caption            :string(255)
#  taken_on           :date
#  user_id            :integer
#  created_at         :datetime
#  updated_at         :datetime
#

class Moment < ActiveRecord::Base
  include Filterable
  filterable_by date: :taken_on
  include Traversable
  traversable_by :taken_on

  belongs_to :user
  has_attached_file :photo, styles: {
    original: '640x640#',
    thumb: '160x160#',
    medium: '320x320#'
  }

  scope :sorted, -> { order taken_on: :desc, created_at: :desc }

  auto_strip_attributes :caption
  validates :caption, length: { within: 4..128 },
                 allow_blank: true
  validates :user, presence: true
  validates_attachment :photo, presence: true,
                           content_type: { content_type: [ 'image/jpg', 'image/jpeg', 'image/gif', 'image/png'],
                                                message: I18n.t('activerecord.errors.models.moment.attributes.photo.invalid') },
                                   size: { in: 0..5.megabytes }
end
