module Kernel
  def is_model?
    is_a?(ActiveRecord::Base) || self.class.included_modules.include?(ActiveModel::Model)
  end
end

module Boolean; end
class TrueClass; include Boolean; end
class FalseClass; include Boolean; end

module ActionView
  module Helpers
    module DateHelper
      def short_distance_of_time_in_words_to_now(from_time, include_seconds_or_options = {})
        short_time_ago_in_words from_time, include_seconds_or_options
      end

      def short_time_ago_in_words(from_time, include_seconds_or_options = {})
        result = distance_of_time_in_words_to_now from_time, include_seconds_or_options
        result.gsub(/^[a-z ]+(?=\d)/i, '') # remove initial text
              .gsub(/(?<=\d) [[:alpha:]]+/) { |m| m.strip.first } # 13 hours to 13h
              .scan(/\d+\w/).join ' ' # remove extra text such as around, less than, etc.
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

  def tclassify_and_constantize
    ActiveSupport::Inflector.tclassify_and_constantize(self)
  end
end

class Array
  def each_with_prev_and_next
    each_with_index do |item, i|
      yield item, fetch(i - 1, last), fetch(i + 1, first)
    end
  end

  def to_h
    Hash[self]
  end

  def mean
    sum.to_f / count
  end
end

class Hash
  def map_values
    update(self) { |k,v| yield v }
  end
end

class Range
  def time_step(step, &block)
    return enum_for(:time_step, step) unless block_given?

    start_time, end_time = first, last
    begin
      yield(start_time)
    end while (start_time += step) <= end_time
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

  module Inflector
    def self.tclassify_and_constantize(table_name)
      model_names = I18n.t('activerecord.models').map_values &:underscore
      model = model_names.keys.detect do |name|
        tname = model_names[name]
        [ tname, tname.pluralize(I18n.locale) ].include? table_name
      end
      (model || table_name).to_s.classify.constantize
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

module ValidateAttribute
  def self.included(base)
    base.send :include, InstanceMethods
  end

  module InstanceMethods
    def valid_attribute?(attribute_name)
      valid_attributes? attribute_name
    end

    def valid_attributes?(*attribute_names)
      self.valid?
      attribute_names.all? { |name| self.errors[name].blank? }
    end
  end
end

ActiveRecord::Base.send(:include, ValidateAttribute) if defined?(ActiveRecord::Base)