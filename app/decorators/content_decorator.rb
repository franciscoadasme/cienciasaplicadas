class ContentDecorator < Draper::Decorator
  def body
    object.body
          .gsub(%r{(^<div>)|(<\/div>$)}, '') # remove enclosing div
          .split(/\s*<br><br>\s*/) # replace double line breaks with p tags
          .map { |text| h.content_tag(:p, text, nil, false) }.join('')
          .gsub(/<br>(?=<)/, '') # remove ending line breaks
          .html_safe
  end
end
