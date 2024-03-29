module Admin::HtmlHelper
# Title helpers
  def content_for_title
    content_for(:title) || tv('.title', default: taction)
  end

  def content_for_subtitle
    case
    when content_for?(:raw_subtitle) then content_for(:raw_subtitle)
    else
      content = case
        when content_for?(:subtitle) then content_for(:subtitle)
        when tv?('.subtitle') then tv('.subtitle')
        else
          controller_name = top_level_controller
          case controller_name
          when 'account' then 'Cuenta'
          when 'group' then 'Grupo'
          else
            controller_name.classify.constantize.model_name.human.pluralize(:'es-CL') rescue controller_name
          end
      end
      content_tag :small, content
    end
  end

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

    options[:target] = '_blank' if options[:blank]
    options[:title] = name if options[:icon_only]

    icon = options.delete :icon
    content = icon.blank? ? name : fa_icon(icon, text: options[:icon_only] ? nil : name)
    link_to content, href, options
  end

  def show_action_for(record, options = {})
    scoped = options.fetch(:scoped, true)
    href = record.is_model? && scoped ? [ :admin, record ] : record
    item_action options.fetch(:name, 'Visualizar'), href, options
  end

  def edit_action_for(record, options = {})
    href = record.is_model? ? [ :edit, :admin, record ] : record
    item_action options.fetch(:name, 'Editar'), href, options
  end

  def delete_action_for(record, options = {})
    options.reverse_merge!(
      method: :delete,
      data: { confirm: options.fetch(:message, 'Está seguro de eliminar este registro?') },
      type: :danger,
      icon: 'trash-o')
    href = record.is_model? ? [ :admin, record ] : record
    item_action options.fetch(:name, 'Eliminar'), href, options
  end

  def sidebar_menu_item(title_or_controller, path_or_options=nil, options={}, &block)
    path = sidebar_menu_item_path title_or_controller, path_or_options

    css = [ 'sidebar-menu-item' ]
    css << path_or_options.delete(:class).try(:split) if path_or_options.is_a?(Hash)
    css << options.delete(:class).try(:split)
    css << 'active' if sidebar_menu_item_active?(title_or_controller, path_or_options, options)
    html_options = path_or_options.is_a?(Hash) ? path_or_options.merge(options) : options

    content_tag :li, class: css.compact.join(' ') do
      link_to(path, html_options) do
        concat sidebar_menu_item_title(title_or_controller)
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

  private
    def sidebar_menu_item_active?(title_or_controller, path_or_options, options)
      case
      when options.has_key?(:condition)
        options.delete(:condition)
      when path_or_options.is_a?(String)
        current_path?(path_or_options) || current_page?(path_or_options)
      when path_or_options.nil? || path_or_options.is_a?(Hash)
        case
          when path_or_options.try(:has_key?, :condition)
            path_or_options.delete(:condition)
          when title_or_controller.is_a?(Symbol)
            controller?(title_or_controller)
        end
      else false
      end
    end

    def sidebar_menu_item_path(title_or_controller, path_or_options)
      case path_or_options
      when String then path_or_options
      when Hash
        path_or_options = path_or_options.extract! :scope, :controller, :action, :id
        case
        when path_or_options.empty? then path_to_index(title_or_controller)
        when path_or_options.has_key?(:scope) && path_or_options.exclude?(:controller) && path_or_options.exclude?(:action)
          [ title_or_controller, :admin, path_or_options[:scope] ]
        else path_or_options
        end
      else path_to_index(title_or_controller)
      end
    end

    def sidebar_menu_item_title(title_or_controller)
      case
      when title_or_controller.is_a?(Symbol)
        content = I18n.t title_or_controller, scope: [ :views, :admin, :_sidebar, :items ]
        if content.start_with?('translation missing')
          model = title_or_controller.to_s.classify.constantize
          model.model_name.human.pluralize(:'es-CL').capitalize rescue content
        else content
        end
      else title_or_controller
      end
    end
end
