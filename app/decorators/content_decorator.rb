# Base decorator for models having user-created content (e.g., post)
class ContentDecorator < Draper::Decorator
  # TODO: avoid this hack to ensure well-formed html
  def body
    @body ||= h.paragraphify(object.body)
               .gsub %r{<(/?)h1>}, '<\1h2>'
    @body.html_safe
  end
end
