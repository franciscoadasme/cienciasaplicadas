class PublicationDecorator < Draper::Decorator
  delegate_all

  def authors
    @authors ||= object.authors.sorted.decorate
  end

  def link
    content = h.content_tag :b, object.title.html_safe
    return content if object.url.blank?
    h.link_to publication.link, class: 'link-unstyled', target: '_blank' do
      h.concat content
      h.concat ' '
      h.concat h.fa_icon(:'external-link', class: 'text-muted')
    end
  end

  def journal_link
    content = h.content_tag :i, object.journal.name
    return content if object.journal.website_url.blank?
    h.link_to content, object.journal.website_url, class: 'text-muted'
  end

  def meta
    h.capture do
      h.concat journal_link
      h.concat ', '
      h.concat h.content_tag(:b, object.year)
      if object.volume.present?
        h.concat ', '
        h.concat h.content_tag(:i, object.volume)
        h.concat " (#{object.issue})" if object.issue.present?
      end
      if pages.present?
        h.concat ', '
        h.concat pages
      end
    end
  end

  def pages
    return object.doi if object.start_page.blank?
    return object.start_page if object.end_page.blank?
    "pp #{start_page}&ndash;#{end_page}".html_safe
  end
end
