# == Schema Information
#
# Table name: events
#
#  abstract_deadline              :date
#  abstract_section               :text
#  abstract_template_content_type :string
#  abstract_template_file_name    :string
#  abstract_template_file_size    :integer
#  abstract_template_updated_at   :datetime
#  created_at                     :datetime
#  description                    :text
#  end_date                       :date
#  event_type                     :string(255)      not null
#  id                             :integer          not null, primary key
#  localized_abstract_section     :text
#  localized_description          :text
#  location                       :string(255)      not null
#  managed                        :boolean          default(FALSE)
#  max_attendee                   :integer
#  name                           :string(255)      not null
#  picture_content_type           :string(255)
#  picture_file_name              :string(255)
#  picture_file_size              :integer
#  picture_updated_at             :datetime
#  promoter                       :string(255)
#  registration_enabled           :boolean          default(FALSE)
#  slug                           :string(255)
#  start_date                     :date             not null
#  tagline                        :string(128)
#  updated_at                     :datetime
#

class Event < ActiveRecord::Base
  include Editable

  TYPES = [ :charla, :congreso, :curso ]
  TEMPLATE_CONTENT_TYPES = [
    'application/msword',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
  ].freeze

  extend FriendlyId
  friendly_id :tagline, use: :slugged

  include Filterable
  filterable_by date: :start_date
  include Traversable
  traversable_by :start_date

  before_save :set_tagline

  has_many :abstracts, dependent: :destroy
  has_many :attendees, dependent: :delete_all
  has_many :posts, dependent: :delete_all
  has_many :speakers, dependent: :delete_all
  has_attached_file :picture
  has_attached_file :abstract_template

  scope :managed, -> { where managed: true }
  scope :sorted, -> { order start_date: :desc }
  scope :typed, -> type { where event_type: type }
  scope :upcoming, -> { where 'start_date > ?', DateTime.current }

  auto_strip_attributes :name, :location, :description
  validates :name, presence: true,
                     length: { in: 4..128 }
  validates :tagline, length: { in: 4..128, allow_blank: true },
                      uniqueness: true,
                      format: { with: /\A[a-z0-9\-_]+\Z/i }
  validates :start_date, presence: true,
                       timeliness: true
  validates :end_date, timeliness: { on_or_after: :start_date },
                      allow_blank: true
  validates :location, presence: true
  validates :description, presence: true,
                            length: { minimum: 10 }
  validates :localized_description, allow_blank: true,
                                    length: { minimum: 10 }
  validates :abstract_section, allow_blank: true, length: { minimum: 10 }
  validates :localized_abstract_section, allow_blank: true,
                                         length: { minimum: 10 }
  validates :abstract_deadline, allow_blank: true,
                                timeliness: { on_or_after: Date.today,
                                              if: -> { abstract_deadline_changed? } }
  validates :event_type, presence: true,
                        inclusion: { in: TYPES.map(&:to_s) }
  validates_attachment :picture, content_type: { content_type: [ 'image/jpg', 'image/jpeg', 'image/gif', 'image/png'],
                                                      message: I18n.t('activerecord.errors.models.event.attributes.picture.spoofed_media_type') },
                                         size: { less_than: 5.megabytes }
  validates_attachment :abstract_template,
                       content_type: { content_type: TEMPLATE_CONTENT_TYPES },
                       size: { less_than: 2.megabytes }

  def self.at_current_month
    date = Date.today
    where start_date: date.beginning_of_month..date.end_of_month
  end

  def accepts_abstract?
    abstract_deadline && abstract_deadline >= Date.today
  end

  def slots_left
    max_attendee - attendees.accepted.count
  end

  def one_day?
    end_date.blank? || start_date == end_date
  end

  def subscribable?
    registration_enabled? && attendees.accepted.count <= max_attendee
  end

  def translate_abstract_section(locale)
    return abstract_section if localized_abstract_section.blank?
    locale.to_sym == :en ? localized_abstract_section : abstract_section
  end

  def translate_description(locale)
    return description if localized_description.blank?
    locale.to_sym == :en ? localized_description : description
  end

  private

  def autogenerate_tagline?
    tagline.blank? || (name_changed? && tagline == name_was.try(:parameterize))
  end

  def set_tagline
    self.tagline = name.parameterize if autogenerate_tagline?
    true
  end

  def should_generate_new_friendly_id?
    set_tagline if new_record?
    slug.blank? || tagline_changed?
  end
end
