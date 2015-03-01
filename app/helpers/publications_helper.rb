module PublicationsHelper
  def author_list_for(pub, truncate: false)
    authors = pub.persisted? ? pub.authors.sorted : pub.authors
    nchars = ndisplayed = 0
    content_tag :ul, class: 'publication-authors' do
      authors.each do |author|
        nchars += author.display_name.length
        break if truncate.kind_of?(Numeric) && truncate > 0 && nchars > truncate
        concat author_item_for(author)
        concat "\n"
        ndisplayed += 1
      end

      undisplayed_count = pub.authors.count - ndisplayed
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
    template = '%{journal}, %{year}'
    template += use_labels && !pub.pending? ? ', Volumen %{volume}' : ', %{volume}'
    if include_issue && pub.issue.present?
      template += use_labels ? ', Número %{issue}' : ' (%{issue})'
    end
    if pub.start_page.present?
      template += use_labels ? ', Páginas %{pages}' : ', %{pages}'
    end

    data = {
      journal: link_to_journal(pub.journal),
      year: content_tag(:b, pub.year, class: 'publication-year'),
      volume: pub.volume,
      issue: pub.issue,
      pages: pub.pages}
    sprintf(template, data).html_safe
  end

  private
    def author_item_more(pub, author_count)
      authors = pub.authors.sorted.to_a.from -author_count
      content_tag :li, class: 'more' do
        concat ' y '
        concat link_to("#{author_count} más",
          '#',
          title: authors.map(&:display_name).join('; '),
          class: 'author_item_more')
      end
    end

    def link_to_journal(journal)
      link_to journal.name, journal.website_url, class: 'publication-journal'
    end
end
