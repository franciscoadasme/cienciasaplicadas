module Localizable
  extend ActiveSupport::Concern

  included do
    result = I18n.t("activerecord.methods.#{model_name.singular}")
    result.each do |old_name, new_name|
      self.singleton_class.send :alias_method, new_name, old_name
    end if result.is_a? Hash
  end
end