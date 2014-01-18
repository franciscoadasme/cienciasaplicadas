module PublicationsHelper
  def author_list_for(pub)
    pub.authors.sorted.map(&:name).join '; '
  end

  def abbreviated_authors_for(pub, options = {})
    options[:class] ||= 'publication-authors'
    content_tag :span, options do
      case pub.authors.count
      when 1 then pub.authors.first.display_name
      when 2 then pub.authors.limit(2).map(&:display_name).join(' & ')
      else
        concat pub.authors.first.display_name
        concat ' '
        concat content_tag(:span, 'et al.', class: 'text-muted')
      end
    end
  end

  def publication_meta_for(pub)
    meta = link_to pub.journal.name, '#', class: 'publication-journal'
    meta += ", #{content_tag :b, pub.year, class: 'publication-year'}".html_safe
    meta += ", #{"Volume " unless pub.pending?}#{pub.volume}" unless pub.volume.blank?
    meta += ", Issue #{pub.issue}" unless pub.issue.blank?
    meta += ", Pages #{pub.pages}" unless pub.start_page.blank?
  end
end
