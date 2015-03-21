module Publishable
  extend ActiveSupport::Concern

  included do
    include Editable
    
    belongs_to :author, class_name: 'User'
    belongs_to :edited_by, class_name: 'User'

    scope :published, -> { where published: true }

    auto_strip_attributes :title, :body
    validates :title, presence: true,
                        length: { within: 4..255 }
    validates :body, presence: true,
                       length: { minimum: 10 }
  end

  def edited_by_author?
    author_id == edited_by_id
  end

  def publish!
    update published: true
  end

  def published?
    published
  end

  def withheld?
    !published?
  end

  def withhold!
    update published: false
  end
end
