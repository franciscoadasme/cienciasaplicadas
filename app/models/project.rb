# == Schema Information
#
# Table name: projects
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  leader_id   :integer
#  start_year  :integer
#  end_year    :integer
#  source      :string(255)
#  identifier  :string(255)
#  description :text
#  image_url   :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Project < ActiveRecord::Base
  auto_strip_attributes :title, :source, :identifier, :image_url

  belongs_to :leader, class_name: 'User'
  has_and_belongs_to_many :collaborators, class_name: 'User'
  has_and_belongs_to_many :external_users

  default_scope { order start_year: :desc, title: :asc }

  VALID_TITLE_REGEX = /\A[[:alpha:] ,\.'-:]+\Z/i
  validates :title, presence: true,
                      format: { with: VALID_TITLE_REGEX },
                      length: { within: 10..255 },
                  uniqueness: true
  validates :leader, presence: true,
                    exclusion: { within: -> p { p.collaborators }}
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

  def all_collaborators
    (collaborators + external_users).sort_by{ |c| [ c.first_name.upcase, c.last_name.upcase ] }
  end

  def source_and_id
    "#{source} No. #{identifier}"
  end

  def self.related_to_user(user)
    includes(:collaborators).where('projects.leader_id = ? OR users.id = ?', user.id, user.id).references(:projects, :users).uniq
  end
end
