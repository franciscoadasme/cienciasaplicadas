module NavHelper
  def nav_main_item(content, href, html_options = {})
    css = [ html_options[:class].try(:split) || 'nav-item' ]
    css << 'active' if current_page?(href)
    content_tag :li do
      link_to content, href, html_options.merge(class: css.compact.join(' '))
    end
  end

  def nav_alt_item(content, icon_name, controller)
    css = [ 'nav-item' ]
    css << 'active' if controller?(controller)

    html_options = {
      title: "Ir a #{content}",
      class: css.join(' ')
    }
    content = fa_icon("#{icon_name}", text: content)
    href = send("#{controller}_path") rescue '#'

    content_tag :li, link_to(content, href, html_options)
  end

  def nav_date_widget(from, to, path, step = 1.month)
    content_tag :ul, class: 'nav nav-pills nav-justified nav-date' do
      concat nav_date_widget_item_tag(I18n.t('views.nav.date.all'), send(path))

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
end
