module NavHelper
  def nav_item(name, options = {}, html_options = {}, &block)
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

  def nav_item_tag(name, options = {}, html_options = {}, &block)
    is_active = (block_given? ? options : html_options).delete(:active) do |_|
      current_page?(options)
    end
    content_tag :li, class: (is_active ? 'active' : nil) do
      link_to(name, options, html_options, &block)
    end
  end
end
