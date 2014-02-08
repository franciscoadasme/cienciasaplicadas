# == Schema Information
#
# Table name: events
#
#  id                   :integer          not null, primary key
#  name                 :string(255)      not null
#  start_date           :date             not null
#  end_date             :date
#  location             :string(255)      not null
#  description          :text
#  event_type           :string(255)      not null
#  promoter             :string(255)
#  picture_file_name    :string(255)
#  picture_content_type :string(255)
#  picture_file_size    :integer
#  picture_updated_at   :datetime
#  created_at           :datetime
#  updated_at           :datetime
#  slug                 :string(255)
#

class Event < ActiveRecord::Base
  TYPES = [ :talk, :seminar, :course ]

  extend FriendlyId
  friendly_id :name, use: [ :slugged ]

  has_attached_file :picture, styles: {
    original: '640x640#',
    thumb: '320x320#'
  }

  scope :sorted, -> { order start_date: :desc }

  auto_strip_attributes :name, :location, :description
  validates :name, presence: true,
                     length: { in: 4..128 }
  validates :start_date, presence: true,
                       timeliness: true
  validates :end_date, timeliness: { on_or_after: :start_date },
                      allow_blank: true
  validates :location, presence: true
  validates :description, length: { minimum: 10 },
                     allow_blank: true
  validates :event_type, presence: true,
                        inclusion: { in: TYPES.map(&:to_s) }
  validates_attachment :picture, content_type: { content_type: [ 'image/jpg', 'image/jpeg', 'image/gif', 'image/png'] },
                                         size: { less_than: 5.megabytes }
end
