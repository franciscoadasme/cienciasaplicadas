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
#

class Author < ActiveRecord::Base
  belongs_to :user
  belongs_to :publication

  default_scope -> { order :id }
  scope :linked, -> { where.not user_id: nil }
  scope :unlinked, -> { where user_id: nil }

  def display_name
    case
    when user.nil?, user.settings.display_author_name
      name
    else
      user.display_name
    end
  end
end
