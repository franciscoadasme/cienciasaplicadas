# Base decorator for models having user-created content (e.g., post)
class ContentDecorator < Draper::Decorator
  def body
    object.body.html_safe
  end
end
