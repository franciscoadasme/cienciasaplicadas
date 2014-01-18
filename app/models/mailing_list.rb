class MailingListMember
  include ActiveModel::Model

  attr_accessor :name, :address, :subscribed, :vars
  alias_method :email, :address

  class << self
    def of_list(address)
      to_record Mailgun.client.list_members(address).list
    end

    private
      def to_record(data)
        case data
        when Array
          data.map { |row| MailingListMember.new(row) }
        when Hash
          MailingListMember.new data.with_indifferent_access[:member]
        end
      end
  end

  def display_name
    user.try(:display_name) || contact.try(:display_name) || name.compact || address
  end

  def image_url
    user.try :image_url
  end

  def contact
    @contact ||= Contact.find_by email: email
  end

  def user
    @user ||= User.find_by(email: email)
  end
end

class MailingList
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks
  include ActiveRecord::AttributeAssignment
  include Seedable

  before_validation :append_domain_if_needed

  attr_accessor :name, :address, :description, :members_count, :created_at, :access_level

  VALID_NAME_REGEX = /[a-z ]+/i
  VALID_ADDRESS_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, format: { with: VALID_NAME_REGEX },
                   length: { within: 4..20 },
              allow_blank: true
  validates :address, presence: true,
                        format: { with: VALID_ADDRESS_REGEX },
                     exclusion: { within: -> ml { MailingList.all.map(&:address) },
                                 message: 'already exists',
                                      on: :create }
  validates_each :address do |record, attr, value|
    record.errors.add(attr, 'has an invalid domain') unless value.strip.split('@').last == ENV['MAILGUN_DOMAIN']
  end

  class << self
    def all
      Rails.cache.fetch('all_mailing_lists', expires_in: 1.hour) do
        to_record Mailgun.client.lists.list
      end
    end

    def create(params)
      new(params).create
    end

    def create!(params)
      new(params).create!
    end

    def find(id)
      begin
        Rails.cache.fetch("/mailing_list/#{id}", expires_in: 1.hour) do
          id.concat("@#{ENV['MAILGUN_DOMAIN']}") unless id.include? ENV['MAILGUN_DOMAIN']
          to_record Mailgun.client.lists.find(id)
        end
      rescue Mailgun::Error
        raise RecordNotFound, "Couldn't find #{@klass.name} with address=#{id}"
      end
    end

    def global
      find 'users'
    end

    def with_address(address)
      all.select { |mailing_list| mailing_list.include? address }
    end

    def table_name
      :mailing_lists
    end
  end

  def addresses
    members.map &:address
  end

  def add_member(address)
    Mailgun.client.list_members(self.address).add address
    Rails.cache.delete "/mailing_list/#{to_param}/members"
  end

  def include?(object)
    members.find { |member| member == object || member.address == object}
  end

  def destroy
    begin
      Mailgun.client.lists.delete address
      Rails.cache.delete 'all_mailing_lists'
    rescue Mailgun::Error
      raise ActiveRecord::RecordNotFound
    end
  end

  def members
    begin
      Rails.cache.fetch("/mailing_list/#{to_param}/members") do
        MailingListMember.of_list(address).sort_by &:display_name
      end
    rescue Mailgun::Error
      raise ActiveRecord::RecordNotFound
    end
  end

  def persisted?
    created_at.present?
  end

  def remove_member(address)
    Mailgun.client.list_members(self.address).remove address
    Rails.cache.delete "/mailing_list/#{to_param}/members"
  end

  def reserved?
    to_param == MailingList.load_seeds.first['address']
  end

  def create
    begin
      create!
    rescue Mailgun::Error
      self.errors.add 'address', 'is invalid for some unknown reason. Maybe it went out of sync with Mailgun service.'
      false
    rescue ActiveSupport::RecordInvalid
      false
    end
  end

  def create!
    if valid?
      Mailgun.client.lists.create(address, to_hash)
      Rails.cache.delete 'all_mailing_lists'
      created_at = DateTime.current
    else
      raise ActiveSupport::RecordInvalid
    end
  end

  def to_hash
    { name: name, address: address, description: description }
  end

  def to_param
    address.split('@').first
  end

  def update(params = nil)
    params ||= to_hash
    if valid?
      begin
        Mailgun.client.lists.update(address, params.fetch(:address, address), params)
        assign_attributes params
        Rails.cache.write "/mailing_list/#{to_param}", self
        Rails.cache.delete 'all_mailing_lists'
        true
      rescue Mailgun::Error, ActiveRecord::RecordInvalid
        self.errors.add 'address', 'couldn\'t save for some unknown reason. Maybe it went out of sync with Mailgun service.'
        false
      end
    else
      false
    end
  end

  def update_member(old_address, address)
    remove_member old_address
    add_member address
  end

  private
    def self.to_record(data)
      case data
      when Array
        data.map { |row| MailingList.new(row) }
      when Hash
        MailingList.new data.with_indifferent_access[:list]
      end
    end

    def append_domain_if_needed
      address.concat("@#{ENV['MAILGUN_DOMAIN']}") unless address.include? '@'
    end
end