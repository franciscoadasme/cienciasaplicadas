module PublicationsHelper
  def author_list_for(pub, limit: 2)
    authors_to_display = pub.authors.sorted.limit(limit)
    content_tag :ul, class: 'publication-authors' do
      authors_to_display.each do |author|
        concat author_item_for(author)
        concat ' '
      end

      undisplayed_count = pub.authors.count - limit
      concat author_item_more(pub, undisplayed_count) if undisplayed_count > 0
    end
  end

  def author_item_for(author)
    content_tag :li do
      content = author.display_name
      if author.has_user?
        if author.user == @user then content_tag :em, content
        else link_to(content, author.user)
        end
      else content
      end
    end
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

  def publication_meta_for(pub, use_labels: true, include_issue: true)
    meta = link_to pub.journal.name, pub.journal.website_url, class: 'publication-journal'
    meta += ", #{content_tag :b, pub.year, class: 'publication-year'}".html_safe
    meta += ", #{'Volumen ' if use_labels && !pub.pending?}#{pub.volume}" unless pub.volume.blank?
    meta += ", #{'Número ' if use_labels}#{pub.issue}" if include_issue && pub.issue.present? && !pub.issue.zero?
    meta += ", #{'Páginas ' if use_labels}#{pub.pages}" unless pub.start_page.blank?
  end

  private
    def author_item_more(pub, author_count)
      content_tag :li, class: 'more' do
        concat ' y '
        concat link_to("#{author_count} más",
          [ :author_list, :admin, pub ],
          title: 'Ver todos los autores',
          class: 'author_item_more',
          remote: true)
      end
    end
end
