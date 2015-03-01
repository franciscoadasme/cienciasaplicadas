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
      concat author_item_more(authors, ndisplayed) if ndisplayed < authors.count
    end
  end

  def author_item_for(author)
    content_tag :li do
      content = author.display_name
      author.has_user? ? link_to(content, user_path(author.user_id)) : content
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
    def author_item_more(authors, ndisplayed)
      authors = authors.to_a.from ndisplayed
      content_tag :li, class: 'more' do
        concat ' y '
        concat link_to("#{authors.count} más",
          '#',
          title: authors.map(&:display_name).join('; '),
          class: 'author_item_more')
      end
    end

    def link_to_journal(journal)
      link_to journal.name, journal.website_url, class: 'publication-journal'
    end
end
