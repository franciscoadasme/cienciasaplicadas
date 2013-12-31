class ExternalUser < ActiveRecord::Base
  has_and_belongs_to_many :projects

  default_scope -> { order :first_name, :last_name  }

  validates :first_name, presence: true,
                           format: { with: User::VALID_NAME_REGEX },
                           length: { in: 3..20 }
  validates :last_name, presence: true,
                          format: { with: User::VALID_NAME_REGEX },
                          length: { in: 3..40 }
  validates :website_url, url: true,
                  allow_blank: true

  def display_name
    full_name
  end

  def external?
    true
  end

  def full_name
    "#{first_name.split.first} #{last_name}" rescue nil
  end
end
