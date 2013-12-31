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

  extend FriendlyId
  friendly_id :tagline, use: [ :slugged, :scoped ], scope: :owner

  belongs_to :owner, class_name: 'User'
  acts_as_list scope: :owner

  default_scope -> { order :position }
  scope :global, -> { where owner_id: nil }

  auto_strip_attributes :tagline
  validates :tagline, presence: true,
                        length: { within: 4..20 },
                    uniqueness: { case_sensitive: false,
                                           scope: :owner_id }

# Status
  def drafted?
    !published? and !trashed?
  end

  def restore!
    update_column :trashed, false
  end

  def status
    case
    when trashed?
      :trashed
    when published?
      :published
    else
      :drafted
    end
  end

  def trash!
    update_column :trashed, true
    Group.first.unmark_page! self
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
    Group.first.marked_page? self
  end

  def marked_as
    Group.first.page_marked_as self
  end
end
