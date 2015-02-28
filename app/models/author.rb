# == Schema Information
#
# Table name: authors
#
#  id             :integer          not null, primary key
#  name           :string(255)      not null
#  user_id        :integer
#  publication_id :integer
#  created_at     :datetime
#  updated_at     :datetime
#  flagged        :boolean
#

class Author < ActiveRecord::Base
  belongs_to :user
  belongs_to :publication

  scope :sorted, -> { order :id }
  scope :linked, -> { where.not user_id: nil }
  scope :unlinked, -> { where user_id: nil }
  scope :with_user, -> user { where user: user }

  def display_name
    case
    when !has_user?, user.settings.display_author_name
      name
    else
      user.display_name
    end
  end

  def has_user?
    user_id.present?
  end

  def flagged?
    flagged
  end

  def toggle_flag!
    update flagged: !flagged?
  end
end
