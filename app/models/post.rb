# == Schema Information
#
# Table name: posts
#
#  id           :integer          not null, primary key
#  title        :string(255)
#  slug         :string(255)
#  author_id    :integer
#  edited_by_id :integer
#  body         :text
#  published    :boolean          default(FALSE)
#  created_at   :datetime
#  updated_at   :datetime
#  view_count   :integer
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
