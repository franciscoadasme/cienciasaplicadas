module Seedable
  extend ActiveSupport::Concern

  module ClassMethods
    def load_seeds
      YAML.load_file("#{Rails.root}/db/seeds/#{table_name}.yml")
    end

    def seed!(override_attributes = {})
      load_seeds.each do |data|
        create! data.merge(override_attributes)
      end
    end
  end
end