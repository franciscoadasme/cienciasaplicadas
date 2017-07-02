module NavHelper
  def nav_item(name, options = nil, html_options = {}, &block)
    nav_item_tag name, options, html_options, &block
  end

  # TODO: change controller argument to href
  def nav_item_icon(content, icon_name, controller, html_options = {})
    html_options[:title] = "Ir a #{content}"
    html_options[:active] = controller.to_s == controller_name
    content = fa_icon(icon_name.to_s)
    href = html_options.delete(:href) || send("#{controller}_url")
    nav_item_tag content, href, html_options
  end

  def nav_date_widget(from, to, path, step = 1.month, acc_items = [])
    content_tag :ul, class: 'nav nav-pills nav-justified nav-date' do
      concat nav_date_widget_item_tag(I18n.t('views.nav.date.all'), send(path))
      acc_items.each do |item|
        concat nav_date_widget_item_tag(item[:title], item[:path])
      end

      (from..to).time_step(step) do |date|
        format_name = date == from || date == to ? :abbr : :month
        concat nav_date_widget_item_for(date, path, format_name)
      end
    end
  end

  private
    def nav_date_widget_item_for(date, path_helper, format_name = :month)
      content = I18n.l date, format: format_name
      path_options = { year: date.year, month: date.month }
      href = send path_helper, path_options
      options = {}
      options[:class] = 'current' if date.current_month?
      nav_date_widget_item_tag content, href, options
    end

    def nav_date_widget_item_tag(content, href, options = {})
      css = [options.delete(:class), ('active' if current_page?(href))]
      content_tag :li, class: css.compact.join(' ').strip do
        link_to content, href
      end
    end

  def nav_item_tag(name, options = nil, html_options = {}, &block)
    html_options, options = options, name if block_given?
    html_options ||= {}

    wrapper_options = {}
    wrapper_options[:class] = 'active' if nav_item_active?(options, html_options)
    wrapper_options[:class] = 'disabled' if html_options.delete(:disabled)

    options = url_for(options) if options.is_a?(Hash) # options are query params

    content_tag :li, wrapper_options do
      nav_link_tag name, options, html_options, &block
    end
  end

  def nav_item_active?(options = nil, html_options = {})
    if options.is_a?(Hash)
      params.slice(*options.keys).symbolize_keys == options.compact
    else
      html_options.delete(:active) { |_| current_page?(options) }
    end
  end

  def nav_link_tag(name, options, html_options, &block)
    badge_content = html_options.delete :badge
    return link_to options, html_options, &block if block_given?

    link_to options, html_options do
      concat name
      if badge_content
        concat ' '
        concat content_tag(:span, badge_content, class: 'badge')
      end
    end
  end
end
