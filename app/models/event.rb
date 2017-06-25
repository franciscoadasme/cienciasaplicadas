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
  include Editable

  TYPES = [ :charla, :congreso, :curso ]

  extend FriendlyId
  friendly_id :name, use: [ :slugged ]

  include Filterable
  filterable_by date: :start_date
  include Traversable
  traversable_by :start_date

  has_attached_file :picture, styles: {
    original: '640x640#',
    thumb: '320x320#'
  }

  scope :sorted, -> { order start_date: :asc }
  scope :typed, -> type { where event_type: type }
  scope :upcoming, -> { where 'start_date > ?', DateTime.current }

  auto_strip_attributes :name, :location, :description
  validates :name, presence: true,
                     length: { in: 4..128 }
  validates :start_date, presence: true,
                       timeliness: true
  validates :end_date, timeliness: { on_or_after: :start_date },
                      allow_blank: true
  validates :location, presence: true
  validates :description, presence: true,
                            length: { minimum: 10 }
  validates :event_type, presence: true,
                        inclusion: { in: TYPES.map(&:to_s) }
  validates_attachment :picture, content_type: { content_type: [ 'image/jpg', 'image/jpeg', 'image/gif', 'image/png'],
                                                      message: I18n.t('activerecord.errors.models.event.attributes.picture.spoofed_media_type') },
                                         size: { less_than: 5.megabytes }

  def one_day?
    end_date.blank? || start_date == end_date
  end
end
