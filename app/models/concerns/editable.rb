module Editable
  extend ActiveSupport::Concern

  def edited?
    updated_at - created_at > 15.minutes
  end
end
