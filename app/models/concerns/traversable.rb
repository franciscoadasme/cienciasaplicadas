module Traversable
  extend ActiveSupport::Concern

  def previous
    field = self.class.traversable_field
    self.class.order(field => :desc)
              .find_by("#{field} < ?", send(field))
  end

  def next
    field = self.class.traversable_field
    self.class.order(field => :asc)
              .find_by("#{field} > ?", send(field))
  end

  module ClassMethods
    def traversable_by(field)
      @traversable_field = field
    end

    def traversable_field
      @traversable_field ||= traversable_defaults
    end

    private
      def traversable_defaults
        :id
      end
  end
end