module Admin::PagesHelper
  def excerpt(text, length: 140, omission: nil, separator: ' ~ ')
    sanitized_text = strip_tags markdown(text)
    truncated_text = sanitized_text.truncate length, separator: /\s+/, omission: ''

    remaining_words_count = sanitized_text.gsub(truncated_text, '').scan(/[\w-]+/).size
    unless remaining_words_count == 0
      if omission.present?
        truncated_text += content_tag(:span, separator, class: 'text-muted')
      else
        label = pluralize(remaining_words_count, 'palabra') + ' más'
        omission = content_tag(:span, separator + label, class: 'text-muted')
      end
      truncated_text += omission
    end
    truncated_text.html_safe
  end

  def sortable_pages?
    params[:status] == 'published' && params[:sorting]
  end
end