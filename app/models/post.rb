# == Schema Information
#
# Table name: posts
#
#  author_id    :integer
#  body         :text
#  created_at   :datetime
#  edited_by_id :integer
#  event_id     :integer
#  id           :integer          not null, primary key
#  locale       :string
#  parent_id    :integer
#  published    :boolean          default(FALSE)
#  slug         :string(255)
#  title        :string(255)
#  updated_at   :datetime
#  view_count   :integer          default(0), not null
#

class Post < ActiveRecord::Base
  include Publishable
  include Viewable
  include Filterable
  include Traversable
  traversable_by :created_at, scope: -> { published }

  belongs_to :event
  belongs_to :parent, class_name: 'Post'
  has_many :localized, class_name: 'Post', foreign_key: :parent_id, dependent: :delete_all

  extend FriendlyId
  friendly_id :title, use: [ :slugged ]

  scope :global, -> { where event: nil }
  scope :locale, ->(locale) { where locale: locale }
  scope :main, -> { where parent: nil }
  scope :published, -> { where published: true }
  scope :sorted, -> { order created_at: :desc }

  def locales
    @locales ||= localized.pluck(:locale).concat([locale]).map(&:to_sym)
  end

  def translate(locale)
    return self if self.locale == locale.to_s
    post = parent || self
    Post.where('id = ? or parent_id = ?', post.id, post.id).locale(locale).first || self
  end
end
