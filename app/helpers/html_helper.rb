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
    html = Nokogiri::HTML.fragment(content)
    html.css('h1, h2, h3, h4, h5, h6')
        .select{ |heading| heading['class'].blank? }
        .collect { |heading| heading.xpath('text()').text }
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

  private
    def extract_variant(options)
      options = options.symbolize_keys
      variants = [ :default, :primary, :success, :info, :warning, :danger, :link ]
      variants.select { |variant| options.delete variant }.first
    end
end