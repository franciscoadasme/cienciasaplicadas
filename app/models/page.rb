# == Schema Information
#
# Table name: pages
#
#  id           :integer          not null, primary key
#  title        :string(255)
#  tagline      :string(255)
#  body         :text
#  owner_id     :integer
#  author_id    :integer
#  edited_by_id :integer
#  published    :boolean          default(FALSE)
#  created_at   :datetime
#  updated_at   :datetime
#  trashed      :boolean          default(FALSE)
#  position     :integer
#  slug         :string(255)
#

class Page < ActiveRecord::Base
  include Publishable
  include Seedable

  extend FriendlyId
  friendly_id :tagline, use: [ :slugged, :scoped ], scope: :owner

  belongs_to :owner, class_name: 'User'
  acts_as_list scope: :owner

  default_scope -> { order :position }
  scope :global, -> { where owner_id: nil }
  scope :navigable, -> { global.published.where.not tagline: 'front' }
  scope :named, -> (name) { friendly.find name.to_s }

  auto_strip_attributes :tagline
  validates :tagline, presence: true,
                        length: { within: 4..20 },
                    uniqueness: { case_sensitive: false,
                                           scope: :owner_id }

  def self.named_pages
    @pages ||= load_seeds
  end

# Status
  def drafted?
    !published? and !trashed?
  end

  def restore!
    update_column :trashed, false
  end

  def status
    case
    when trashed? then :trashed
    when published? then :published
    else :drafted
    end
  end

  def trash!
    update_column :trashed, true
  end

  def trashed?
    trashed
  end

# Ownage
  def owned_by? user
    owner == user
  end

  def associated_controller
    persisted? || destroyed? ? (owner.nil? ? 'group' : 'account') : nil
  end

  def marked?
    Page.named_pages.keys.include? tagline
  end

  def marked_as
    tagline
  end
end
