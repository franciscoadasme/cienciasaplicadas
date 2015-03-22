module Viewable
  extend ActiveSupport::Concern

  def increment_view_count!
    self.view_count ||= 0
    update_column :view_count, view_count + 1
  end
end
