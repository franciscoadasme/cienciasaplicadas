# == Schema Information
#
# Table name: publications
#
#  id         :integer          not null, primary key
#  doi        :string(255)
#  url        :string(255)
#  journal    :string(255)
#  volume     :string(255)
#  issue      :integer
#  start_page :integer
#  end_page   :integer
#  month      :integer
#  year       :integer
#  title      :string(1000)
#  identifier :string(255)
#  created_at :datetime
#  updated_at :datetime
#  journal_id :integer
#

class Publication < ActiveRecord::Base
  ALLOWED_FIELDS = [ :identifier, :title, :year, :month, :journal, :volume, :issue, :start_page, :end_page, :url, :doi ]
  DOI_URL = 'http://dx.doi.org/'
  PENDING_LABEL = 'In Press'

  belongs_to :journal
  has_many :authors, dependent: :delete_all
  has_many :users, through: :authors

  scope :sorted, -> { order year: :desc, month: :desc, title: :asc }
  scope :default, -> { sorted }
  scope :flagged, -> { joins(:authors).where(:'authors.flagged' => true).uniq }

  VALID_DOI_REGEX = /\b(10[.][0-9]{4,}(?:[.][0-9]+)*\/(?:(?!["&\'<>])\S)+)\b/

  auto_strip_attributes :doi, :url, :journal, :volume, :start_page, :title

  validates :doi, format: { with: VALID_DOI_REGEX },
              uniqueness: true,
             allow_blank: true
  validates :url, url: true,
          allow_blank: true
  validates :volume, presence: true,
                       format: { with: /\A([1-9]\d*|#{PENDING_LABEL})\Z/i,
                              message: "is neither a valid number nor says \"#{PENDING_LABEL}\"" }
  validates :start_page, numericality: { integer: true,
                                    greater_than: 0 },
                          allow_blank: true
  validates :end_page, numericality: { integer: true,
                                  greater_than: :start_page },
                        allow_blank: true
  validates :year, presence: true,
               numericality: { greater_than_or_equal_to: 1950 }
  validates :title, presence: true,
                  uniqueness: true
  validates :identifier, presence: true,
                       uniqueness: true

  def author_for_user(user)
    authors.with_user(user).first
  end

  def has_user? user
    users.exists? user
  end

  def has_users?
    authors.map(&:user_id).any?
  end

  def link
    doi.try(:prepend, DOI_URL) || url
  end

  def pages
    "#{start_page}-#{end_page}"
  end

  def pending?
    volume == PENDING_LABEL
  end

  def unlinked_authors
    authors.unlinked
  end

  def flagged_by?(user)
    authors.with_user(user).first.flagged?
  end
end
