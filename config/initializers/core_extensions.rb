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
end

module ActiveModel
  class Errors
    def full_unique_messages
      unique_messages = messages.map { |attribute, list_of_messages| [attribute, list_of_messages.first] }
      unique_messages.map { |attribute_message_pair| full_message *attribute_message_pair }
    end
  end
end