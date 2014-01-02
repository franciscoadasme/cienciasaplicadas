module Seedable
  extend ActiveSupport::Concern

  module ClassMethods
    def load_seeds
      HashWithIndifferentAccess.new YAML.load_file("#{Rails.root}/db/seeds/#{table_name}.yml")
    end
  end
end