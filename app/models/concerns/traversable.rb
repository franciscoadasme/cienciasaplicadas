module Traversable
  extend ActiveSupport::Concern

  def previous
    field = self.class.traversable_config[:field]
    scope = self.class.traversable_config[:scope]
    self.class.all.scoping{ scope.call }
                  .order(field => :desc)
                  .find_by("#{field} < ?", send(field))
  end

  def next
    field = self.class.traversable_config[:field]
    scope = self.class.traversable_config[:scope]
    self.class.all.scoping{ scope.call }
                  .order(field => :asc)
                  .find_by("#{field} > ?", send(field))
  end

  module ClassMethods
    def traversable_by(field, options = {})
      @traversable_config = traversable_defaults.merge(options)
      @traversable_config[:field] = field
    end

    def traversable_config
      @traversable_config
    end

    private
      def traversable_defaults
        { field: :id, scope: -> { all } }
      end
  end
end