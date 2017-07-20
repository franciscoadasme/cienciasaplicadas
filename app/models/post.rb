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

  extend FriendlyId
  friendly_id :title, use: [ :slugged ]

  scope :global, -> { where event: nil }
  scope :published, -> { where published: true }
  scope :sorted, -> { order created_at: :desc }
end
