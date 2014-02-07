module HtmlHelper
  def autolink_to name, options = {}, html_options = {}, &block
    link_to name, options, html_options, &block unless current_page?(options)
  end

  def autosizing_image_tag(source, options = {})
    css = 'autosizing'
    style = "background-image: url(\"#{source}\")"
    options[:style] = "#{options[:style]} #{style}".strip
    options[:class] = "#{options[:class]} #{css}".strip
    options[:data] = { size: options.delete(:size) }.merge(options[:data] || {}) if options.key?(:size)
    image_tag(source, options)
  end

  def title(separator = '·')
    case
    when current_page?(root_url), @page.nil?
      @group.name
    when current_page?(contact_url)
      "Contact #{separator} #{@group.abbr}"
    when controller?(:posts)
      "Posts #{separator} #{@group.abbr}"
    when controller?(:users)
      "#{@page.title} #{separator} @#{@user.nickname}"
    else
      "#{@page.title} #{separator} #{@group.abbr}"
    end
  end

  def btn_to(name, href, html_options = {}, &block)
    classes = [ 'btn', "btn-#{extract_variant(html_options) || :default}" ]
    classes << 'btn-block' if html_options.delete(:block)
    html_options[:class] = "#{classes.join ' '} #{html_options[:class]}"
    link_to name, href, html_options, &block
  end

  def html_headings(content)
    content.scan(/<h\d.*>.+<\/h\d>/).map { |heading| strip_tags(heading) }
  end

  def toc_html_headings(content)
    result = content.gsub(/<h\d.*>.+<\/h\d>/) do |heading|
      heading.gsub! /id=".+"/, '' # remove existing id
      id = strip_tags(heading).parameterize
      heading.gsub /(?<=<h\d) */, " id=\"#{id}\""
    end
    result.html_safe
  end

  def collect_image_urls(html)
    html = Nokogiri::HTML.fragment(html)
    html.css('img').select{ |img| img['class'].blank? }
                   .collect { |img| img['src'] }
  end

  def nav_date_widget(from, to, path_helper, step = 1.month, placeholder = 'Todo')
    content_tag :ul, class: 'nav nav-pills nav-justified nav-date' do
      concat nav_date_widget_item(placeholder, send(path_helper))

      (from..to).time_step(step) do |date|
        format = date == from || date == to ? :abbr : :month
        content = I18n.l date, format: format
        path_options = { year: date.year, month: date.month }
        href = send path_helper, path_options

        concat nav_date_widget_item(content, href)
      end
    end
  end

  private
    def nav_date_widget_item(content, href)
      content_tag :li, class: ('active' if current_page?(href)) do
        link_to content, href
      end
    end

    def extract_variant(options)
      options = options.symbolize_keys
      variants = [ :default, :primary, :success, :info, :warning, :danger, :link ]
      variants.select { |variant| options.delete variant }.first
    end
end