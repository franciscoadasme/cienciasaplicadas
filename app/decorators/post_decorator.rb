class PostDecorator < ContentDecorator
  include Draper::LazyHelpers

  delegate_all
  decorates_association :author

  delegate :link, to: :author, prefix: true

  def published_at
    time_tag created_at,
             l(created_at, format: :abbr_with_day),
             pubdate: true
  end

  def view_info
    I18n.t 'views.posts.show.view_info', count: object.view_count
  end
end
