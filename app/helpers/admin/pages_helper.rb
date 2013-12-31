module Admin::PagesHelper
  def excerpt text, length: 140
    sanitized_text = strip_tags markdown(text)
    truncated_text = sanitized_text.truncate length, separator: /\s+/, omission: ''

    remaining_words_count = sanitized_text.gsub(truncated_text, '').scan(/[\w-]+/).size
    unless remaining_words_count == 0
      remaining_words = content_tag(:span, pluralize(remaining_words_count, 'more word'), class: 'text-muted')
      truncated_text += " ~ #{remaining_words}"
    end
    truncated_text.html_safe
  end

  def sortable_pages?
    params[:status] == 'published' && params[:sorting]
  end
end