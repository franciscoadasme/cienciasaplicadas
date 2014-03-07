# == Schema Information
#
# Table name: pages
#
#  id                  :integer          not null, primary key
#  title               :string(255)
#  tagline             :string(255)
#  body                :text
#  owner_id            :integer
#  author_id           :integer
#  edited_by_id        :integer
#  published           :boolean          default(FALSE)
#  created_at          :datetime
#  updated_at          :datetime
#  trashed             :boolean          default(FALSE)
#  position            :integer
#  slug                :string(255)
#  banner_file_name    :string(255)
#  banner_content_type :string(255)
#  banner_file_size    :integer
#  banner_updated_at   :datetime
#

class Page < ActiveRecord::Base
  include Publishable
  include Seedable

  has_attached_file :banner, styles: { original: '1920x1080#',
                                          thumb: '640x360#' },
                    convert_options: { original: '-modulate 100,50,100 -blur 0x2' }

  extend FriendlyId
  friendly_id :tagline, use: [ :slugged, :scoped ], scope: :owner

  belongs_to :owner, class_name: 'User'
  belongs_to :author, class_name: 'User'
  belongs_to :edited_by, class_name: 'User'
  acts_as_list scope: :owner

  default_scope -> { order :position }
  scope :global, -> { where owner_id: nil }
  scope :published, -> { where published: true, trashed: false }
  scope :drafted, -> { where published: false, trashed: false }
  scope :trashed, -> { where trashed: true }
  scope :navigable, -> { global.published }

  def self.named(name)
    friendly.find(name.to_s.parameterize) rescue nil
  end

  before_create :set_edited_by_if_needed

  auto_strip_attributes :tagline
  validates :tagline, presence: true,
                        length: { within: 4..20 },
                    uniqueness: { case_sensitive: false,
                                           scope: :owner_id }
  validates :body, presence: true,
                     length: { minimum: 128 }
  validates_attachment :banner, content_type: { content_type: [ 'image/jpg', 'image/jpeg', 'image/gif', 'image/png'],
                                                     message: I18n.t('activerecord.errors.models.page.attributes.banner.spoofed_media_type') },
                                        size: { in: 0..5.megabytes },
                                 allow_blank: true

  def self.named_pages
    @pages ||= Hash[load_seeds.map { |data| [ data['tagline'], data ] }].with_indifferent_access
  end

  def self.human_state_name(state_i18n_key)
    I18n.t state_i18n_key, scope: Page.i18n_scope_states, default: state_i18n_key
  end

  def self.state_key_for(state_name)
    I18n.t(Page.i18n_scope_states).invert.transform_keys{ |key| key.to_s.parameterize }[state_name.to_s]
  end

  def self.named?(name)
    named(name).try :present?
  end

# Status
  def drafted?
    !published? and !trashed?
  end

  def restore!
    update_column :trashed, false
  end

  def status
    Page.human_state_name case
      when trashed? then :trashed
      when published? then :published
      else :drafted
    end
  end

  def trash!
    update_column :trashed, true
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
    Page.named_pages.keys.include? tagline
  end

  def marked_as
    tagline
  end

  private
    def set_edited_by_if_needed
      self.edited_by ||= author
    end

    def self.i18n_scope_states
      :'activerecord.attributes.page.states'
    end
end
