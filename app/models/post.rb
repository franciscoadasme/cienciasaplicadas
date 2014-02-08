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

  extend FriendlyId
  friendly_id :title, use: [ :slugged ]

  scope :published, -> { where published: true }
  scope :sorted, -> { order created_at: :desc }

  def previous
    Post.limit(1).order(id: :desc).find_by('id < ?', id)
  end

  def next
    Post.limit(1).order(id: :asc).find_by('id > ?', id)
  end
end