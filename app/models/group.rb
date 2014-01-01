# == Schema Information
#
# Table name: groups
#
#  id               :integer          not null, primary key
#  name             :string(255)
#  abbr             :string(255)
#  logo             :string(255)
#  email            :string(255)
#  bio              :text
#  created_at       :datetime
#  updated_at       :datetime
#  banner_image_url :string(255)
#  tagline          :string(255)
#  address          :text
#  about_page_id    :integer
#  front_page_id    :integer
#  users_page_id    :integer
#  pubs_page_id     :integer
#  projects_page_id :integer
#

class Group < ActiveRecord::Base
  PAGE_TYPES = [ :about, :front, :pubs, :users ]
  PAGE_NAMES = %w(about front publications people)

  auto_strip_attributes :name, :abbr, :tagline, :logo, :email, :banner_image_url, :address

  belongs_to :about_page, class_name: 'Page'
  belongs_to :front_page, class_name: 'Page'
  belongs_to :pubs_page, class_name: 'Page'
  belongs_to :users_page, class_name: 'Page'
  belongs_to :projects_page, class_name: 'Page'

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true,
                 uniqueness: { case_sensitive: false }
  validates :abbr, presence: true,
                     length: { within: 3..10 },
                 uniqueness: { case_sensitive: false }
  validates :tagline, length: { within: 10..40 },
                   allow_nil: true
  validates :logo, url: true,
             allow_nil: true
  validates :email, presence: true,
                      format: { with: VALID_EMAIL_REGEX },
                  uniqueness: { case_sensitive: false }
  validates :bio, length: { minimum: 100 },
             allow_blank: true
  validates :banner_image_url, url: true,
                         allow_nil: true
  validates :address, length: { within: 10..128 },
                 allow_blank: true

  def self.default
    Group.create! name: 'Group'
  end

  def display_name
    abbr || name
  end

# Pages
  def mark_page_as!(page, type)
    return unless page.owner.nil? && type.present?

    if marked_page?(page)
      send "#{page_marked_as page, true}_page_id=", nil
    end
    send "#{Group.page_type_for_name(type) || type}_page_id=", page.id
    save
  end

  def marked_page?(page)
    marked_page_ids.compact.include? page.id
  end

  def missing_pages
    marked_page_ids.zip(PAGE_NAMES).select{ |id, name| id.nil? }.map { |id, name| name }
  end

  def self.page_type_name(type)
    Hash[PAGE_TYPES.zip(PAGE_NAMES)][type]
  end

  def self.page_type_for_name(name)
    Hash[PAGE_NAMES.zip(PAGE_TYPES)][name]
  end

  def page_marked_as(page, use_symbols=false)
    labels = use_symbols ? PAGE_TYPES : PAGE_NAMES
    Hash[marked_page_ids.zip(labels)].select{ |id, name| id.present? }[page.id]
  end

  def pages
    Page.where(owner_id: nil)
  end

  def unmarked_pages
    pages.where('id NOT IN (?)', marked_page_ids.compact)
  end

  def unmark_page!(page)
    update! "#{page_marked_as page, true}_page_id" => nil if page.marked?
  end

  private
    def marked_page_ids
      PAGE_TYPES.map { |pn| send("#{pn}_page_id") }
    end
end
