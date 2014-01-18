# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default("")
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  invitation_token       :string(255)
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_id          :integer
#  invited_by_type        :string(255)
#  provider               :string(255)
#  uid                    :string(255)
#  nickname               :string(255)
#  first_name             :string(255)
#  last_name              :string(255)
#  image_url              :string(255)
#  role                   :integer          default(0)
#  headline               :string(255)
#  signature              :text
#  bio                    :text
#  position_id            :integer
#

class User < ActiveRecord::Base
  extend FriendlyId
  friendly_id :nickname

  ROLE_ADMIN = 9
  ROLE_SUPER_USER = 1
  ROLE_USER = 0

  has_many :pages, foreign_key: :owner_id, dependent: :destroy
  has_one :settings, dependent: :delete
  has_many :aliases, class_name: 'Author', dependent: :nullify
  has_many :publications, through: :aliases
  has_many :projects
  belongs_to :position

  default_scope { order :first_name, :last_name, role: :desc, invitation_sent_at: :desc }
  scope :default, -> { where.not(invitation_accepted_at: nil) }

  devise :database_authenticatable,
         #:recoverable,
         :rememberable, :trackable, :validatable,
         :invitable,
         # :aync,
         :omniauthable, omniauth_providers: [ :facebook, :google_oauth2 ]
  attr_reader :raw_invitation_token

  after_invitation_accepted :create_default_settings
  after_invitation_accepted :add_to_mailing_list
  before_destroy :remove_from_mailing_list
  before_update :update_mailing_list_member_if_needed

  def send_reset_password_instructions
    super if accepted?
  end

  # Need to overide this to use our own invitation mailer
  def deliver_invitation
    # Code extracted from devise_invitable model's deliver_invitation method
    generate_invitation_token! unless @raw_invitation_token
    self.update_attribute :invitation_sent_at, Time.now.utc unless self.invitation_sent_at
    #send_devise_notification(:invitation_instructions, @raw_invitation_token)

    InvitationMailer.invite_message(self).deliver
  end

  auto_strip_attributes :first_name, :last_name, :nickname, :headline, :image_url, :signature, :bio

  VALID_NAME_REGEX = /\A[[:alpha:] ,\.'-]+\Z/i
  VALID_NICKNAME_REGEX = /\A[a-z]+$\Z/
  validates :first_name, presence: true,
                           format: { with: VALID_NAME_REGEX },
                           length: { in: 3..20 }
  validates :last_name, presence: true,
                          format: { with: VALID_NAME_REGEX },
                          length: { in: 3..40 }
  validates :nickname, presence: true,
                         format: { with: VALID_NICKNAME_REGEX },
                         length: { in: 3..20 },
                     uniqueness: true
  validates :image_url, url: true,
                allow_blank: true
  validates :headline, length: { in: 4..40 },
                  allow_blank: true
  validates :signature, length: { in: 10..256 },
                   allow_blank: true
  validates :bio, length: { minimum: 100 },
             allow_blank: true
  validates :position, presence: true

  def self.from_omniauth(auth, signed_in_resource=nil)
    user = where("email = ? OR nickname = ? OR (provider = ? AND uid = ?)",
                 auth.info.email, auth.info.nickname,
                 auth.provider, auth.uid).first
    user.tap do |user|
      if !user.settings || user.settings.should_update_attributes?
        user.first_name = auth.info.first_name
        user.last_name = auth.info.last_name

        user.nickname = user.suggested_nickname(auth.info.nickname) if user.nickname.nil? || user.settings.should_update_attribute?(:nickname)
        user.email ||= auth.info.email
        user.image_url = auth.info.image if !user.settings || user.settings.should_update_attribute?(:image_url)
        user.encrypted_password ||= Devise.friendly_token[0,20]
      end

      user.provider = auth.provider
      user.uid = auth.uid

      user.save!
    end unless user.nil?
  end

  def accepted?
    admin? || invitation_token.nil?
  end

  def admin?
    role == ROLE_ADMIN
  end

  def collaborators
    publications.map(&:users).flatten.uniq.select{|u| u != self}
  end
  alias_method :colleagues, :collaborators

  def has_collaborators?
    collaborators.count > 0
  end

  def collaborator?(user)
    collaborators.include?(user)
  end

  def demote!
    update role: ROLE_USER unless admin?
  end

  def display_name
    (accepted? && settings.include_lastname ? full_name : first_name) || nickname || email
  end

  def external?
    false
  end

  def full_name
    "#{first_name.split.first} #{last_name}" rescue nil
  end

  def impact_factor
    journal_ids = publications.pluck(:journal_id).uniq
    Journal.where(id: journal_ids).average(:impact_factor)
  end

  def promote!
    update role: ROLE_SUPER_USER
  end

  def role_name
    case role
    when ROLE_ADMIN then I18n.t('activerecord.attributes.user.roles.admin')
    when ROLE_SUPER_USER then I18n.t('activerecord.attributes.user.roles.super_user')
    when ROLE_USER then I18n.t('activerecord.attributes.user.roles.user')
    end
  end

  def role_symbol
    case role
    when ROLE_ADMIN then :admin
    when ROLE_SUPER_USER then :super_user
    when ROLE_USER then :user
    end
  end

  def suggested_nickname proposed=nil
    base = case
    when proposed.present? then proposed
    else
      if first_name.present? && last_name.present?
        first_name[0].concat last_name.split(' ').first
      else
        email.split('@').first
      end
    end
    ActiveSupport::Inflector.transliterate base.scan(/[a-z]+/).join.downcase
  end

  def super_user?
    [ ROLE_ADMIN, ROLE_SUPER_USER ].include? role
  end

  def alias?(string)
    return true if aliases.pluck(:name).uniq.include?(string.strip)
    lastname, firstname = string.gsub(%r{[\.-]}, ' ').split(',').map(&:normalize)
    matching_lastname?(lastname) and matching_firstname?(firstname)
  end

  def normalized_first_name
    @normalized_first_name ||= first_name.normalize.gsub /[\.-]/, ' '
  end

  def normalized_last_name
    @normalized_last_name ||= last_name.normalize.gsub /[\.-]/, ' '
  end

  private
    def add_to_mailing_list
      MailingList.global.add_member email
      true
    end

    def create_default_settings
      build_settings
    end

    def matching_lastname?(lastname)
      proposed = lastname.downcase.split ' '
      real = normalized_last_name.split ' '

      incomplete, full = [ proposed, real ].sort_by(&:length)
      (full[0..(incomplete.length - 1)] <=> incomplete) == 0
    end

    def matching_firstname?(firstname)
      # firstname.split(' ')[0] == normalized_first_name.split(' ')[0]
      #CLogger.debug "FIRST_NAME: #{normalized_first_name}, AUTHOR_FIRST_NAME: #{firstname}, SCAN: #{normalized_first_name.scan(/^#{firstname}/).any?}, #{firstname.scan(/^#{normalized_first_name}/).any?}\n"
      normalized_first_name.scan(/^#{firstname.split.first}/).any? || firstname.scan(/^#{normalized_first_name}/).any?
    end

    def remove_from_mailing_list
      MailingList.global.remove_member email
      true
    end

    def update_mailing_list_member_if_needed
      MailingList.global.update_member email_was, email if email_changed?
      true
    end
end
