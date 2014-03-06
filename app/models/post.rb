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
#

class Post < ActiveRecord::Base
  include Publishable
  include Filterable
  include Traversable
  traversable_by :created_at, scope: -> { published }

  extend FriendlyId
  friendly_id :title, use: [ :slugged ]

  scope :published, -> { where published: true }
  scope :sorted, -> { order created_at: :desc }
end