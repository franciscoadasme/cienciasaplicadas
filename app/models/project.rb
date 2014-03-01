# == Schema Information
#
# Table name: projects
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  user_id     :integer
#  start_year  :integer
#  end_year    :integer
#  source      :string(255)
#  identifier  :string(255)
#  description :text
#  image_url   :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  position    :string(255)
#

class Project < ActiveRecord::Base
  belongs_to :user

  scope :sorted, -> { order start_year: :desc, title: :asc }

  auto_strip_attributes :title, :position, :source, :identifier, :image_url
  VALID_TITLE_REGEX = /\A[[:alpha:] ,\.'-:]+\Z/i
  validates :title, presence: true,
                      format: { with: VALID_TITLE_REGEX },
                      length: { within: 10..255 },
                  uniqueness: true
  validates :position, presence: true,
                         length: { within: 3..128 }
  validates :start_year, numericality: { only_integer: true },
                          allow_blank: true
  validates :end_year, numericality: { only_integer: true,
                           greater_than_or_equal_to: :start_year },
                        allow_blank: true
  validates :source, presence: true
  validates :identifier, presence: true,
                       uniqueness: true
  validates :image_url, url: true,
                allow_blank: true

  def source_and_id
    "#{source} No. #{identifier}"
  end

  def has_timespan?
    start_year.present?
  end
end
