class PostDecorator < ContentDecorator
  include Draper::LazyHelpers

  delegate_all
  decorates_association :author

  delegate :link, to: :author, prefix: true

  def event
    @event ||= object.event.try :decorate
  end

  def excerpt(truncate_at: 160)
    h.excerpt(object.body, truncate_at: truncate_at, omission: ' [...]')
  end

  def link(html_options = {}, &block)
    return h.link_to permalink, html_options, &block if block_given?
    h.link_to object.title, permalink, html_options
  end

  def permalink
    date = object.created_at
    post_params = { id: object.slug, year: date.year, month: date.month,
                    day: date.day }
    h.post_url post_params.merge(request.query_parameters)
  end

  def published_at
    time_tag created_at,
             l(created_at, format: :abbr_with_day),
             pubdate: true
  end

  def view_info
    I18n.t 'views.posts.show.view_info', count: object.view_count
  end
end
