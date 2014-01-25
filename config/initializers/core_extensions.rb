module Kernel
  def is_model?
    is_a?(ActiveRecord::Base) || self.class.included_modules.include?(ActiveModel::Model)
  end
end

module ActionView
  module Helpers
    module DateHelper
      def short_distance_of_time_in_words_to_now(from_time, include_seconds_or_options = {})
        short_time_ago_in_words from_time, include_seconds_or_options
      end

      def short_time_ago_in_words(from_time, include_seconds_or_options = {})
        result = distance_of_time_in_words_to_now from_time, include_seconds_or_options
        result.gsub(/^[a-z ]+(?=\d)/i, '') # remove initial text
              .gsub(/(?<=\d) [a-z]+/) { |m| m.strip.first } # 13 hours to 13h
      end
    end
  end
end

class String
  alias_method :parent_prepend, :prepend

  def prepend other
    dup.prepend! other
  end

  def prepend! other
    parent_prepend other
  end

  def middle_truncate(length=80, ellipsis="...")
    return self if self.length <= length
    return self[0..length] if length < ellipsis.length
    len = (length - ellipsis.length)/2
    s_len = len - length % 2
    self[0..s_len] + ellipsis + self[self.length-len..self.length]
  end

  def normalize
    ActiveSupport::Inflector.transliterate self.strip.downcase
  end

  def encrypt
    ActiveSupport::MessageEncryptor.default_encryptor.encrypt_and_sign self
  end

  def decrypt
    ActiveSupport::MessageEncryptor.default_encryptor.decrypt_and_verify self
  end

  def compact
    strip.blank? ? nil : strip
  end
end

module ActiveSupport
  class MessageEncryptor
    def self.default_encryptor
      salt  = SecureRandom.random_bytes(64)
      key   = ActiveSupport::KeyGenerator.new('Yuz1wa5b1CT6UzigdPe6').generate_key(salt)
      @crypt ||= new(key)
    end
  end
end

module ActiveModel
  class Errors
    def full_unique_messages
      unique_messages = messages.map { |attribute, list_of_messages| [attribute, list_of_messages.first] }
      unique_messages.map { |attribute_message_pair| full_message *attribute_message_pair }
    end
  end
end