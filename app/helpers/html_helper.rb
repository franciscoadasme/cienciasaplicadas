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

  def navbar_item(name, path, options={})
    content_tag :li, class: ('active' if (options[:condition] || current_page?(path))) do
      icon_name = case name.try(:to_sym)
        # when :publications then 'files-o'
        # when :people then 'group'
        # when :about then 'info'
        when :posts then 'comments-o'
        # when :projects then 'briefcase'
        when :admin then 'lock'
        else
          nil
      end

      title = options[:title] || name.to_s.titleize
      if icon_name.present?
        link_to fa_icon("#{icon_name} fw"), path, title: title
      else
        link_to title, path
      end
    end
  end

  def navbar_page_item(page)
    navbar_item page.marked_as, page_path(page), title: page.title
  end

  def sidebar_user_page_item(user, page)
    path = page_user_path user, page
    content_tag :li, class: ('active' if current_page?(path) || controller?(page)) do
      link_to (page.try(:title) || page.titleize), path
    end
  end

  def body_class
    [ ('wo-nav' if no_nav?),
      ('with-sidebar-fixed' if sidebar_fixed?),
      content_for(:body_class)
    ].compact.join(' ')
  end

  def content_class
    css = []
    case
    when sidebar_fixed?, content_for(:full_width)
      css << 'col-xs-12'
    else
      css << 'col-xs-8'
      css << 'col-xs-offset-2' unless content_for?(:sidebar)
    end
    css.compact.join(' ')
  end

  def nav_class
    [
      ('navbar-fixed-top' unless content_for(:no_nav)),
      ('navbar-static-top' if content_for(:static_nav)),
      content_for(:nav_class)
    ].compact.join(' ')
  end

  def footer_class
    [
      'gr-footer'
    ].compact.join(' ')
  end

  def footer_info_class
    [
      "col-xs-#{sidebar_fixed? ? 4 : 3 }",
      ("col-xs-offset-1" unless sidebar_fixed?)
    ].compact.join(' ')
  end

  def no_nav?
    content_for?(:no_nav)
  end

  def sidebar_fixed?
    content_for?(:sidebar_fixed)
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

  def link_to_user(user)
    content = display_user_name user
    hint = user.external? ? 'External collaborator' : "Go to #{user.display_name}'s public profile"
    html_options = { class: ('user-external' if user.external?), title: hint }
    user.external? && user.website_url.blank? ? content_tag(:span, content, html_options) : link_to(content, user, html_options)
  end
end