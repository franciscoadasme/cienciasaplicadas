module Admin::HtmlHelper
# Item actions
  def item_action(name, href, options = {})
    unless options.has_key? :class
      variant = case
        when options.has_key?(:type) then options.delete(:type)
        when options.delete(:primary) then 'primary'
        else 'default'
      end
      options[:class] = "btn btn-#{variant}"
    end

    icon = options.delete :icon
    content = icon.blank? ? name : fa_icon(icon, text: name)
    link_to content, href, options
  end

  def edit_action_for(record, options = {})
    item_action options.fetch(:name, 'Edit'), [ :edit, :admin, record ], options
  end

  def delete_action_for(record, options = {})
    options.reverse_merge!(
      method: :delete,
      data: { confirm: options.fetch(:message, 'Are you sure?') },
      type: :danger,
      icon: 'trash-o')
    item_action options.fetch(:name, 'Delete'), [ :admin, record ], options
  end

  def markdown_hint
    text = <<EOS
It supports markdown  markup language #{link_to fa_icon('question-circle'), 'http://daringfireball.net/markdown', title: 'What is markdown?', target: '_blank'}. Using online editors such as #{link_to 'Markable', 'http://markable.in/editor/', target: '_blank'}, #{link_to 'Dillinger', 'http://dillinger.io/', target: '_blank'} or #{link_to 'StackEdit', 'http://benweet.github.io/stackedit/', target: '_blank'} is highly recommended.
EOS
    text.html_safe
  end

  def sidebar_menu_item title, path, options={}, &block
    is_active = options.delete(:condition) || current_path?(path) || current_page?(path)
    addon = options.delete :addon
    css = options.delete :class
    content_tag :li, class: "sidebar-menu-item #{css} #{' active' if is_active}" do
      link_to(path, options) do
        concat title.to_s.titleize
        yield if block_given?
      end
    end
  end

  def sidebar_addon content, options={}
    options[:class] = "addon #{options[:class]}"
    content_tag :span, content, options
  end

  def sidebar_badge content, options={}
    options[:class] = "badge #{options[:class]}"
    sidebar_addon content, options
  end

  def vertical_form_for(record, options={}, &block)
    backup = SimpleForm.form_class
    SimpleForm.form_class = options[:form_class]
    result = simple_form_for(record, options, &block)
    SimpleForm.form_class = backup
    result
  end

  def mtable_tag options={}, &block
    width = options.delete(:width) || 600
    content_tag :table, content_tag(:tbody, nil, nil, true, &block), options.merge(border: 0, cellpadding: 0, cellspacing: 0, width: width)
  end

  def tspace_h size
    content_tag :td, '&nbsp;', width: size, style: 'font-size: 0; line-height: 0;'
  end

  def tspace_v size
    content_tag :table, width: '100%' do
      content_tag :tbody do
        content_tag :tr do
          content_tag :td, '&nbsp;', height: size, style: 'font-size: 0; line-height: 0;'
        end
      end
    end
  end
end