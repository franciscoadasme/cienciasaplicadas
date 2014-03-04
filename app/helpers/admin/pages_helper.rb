module Admin::PagesHelper
# Url helpers
  def scoped_pages_path(path_options = {})
    scope = path_options.delete(:scope) || top_level_controller
    path_name = "admin_#{scope}_pages_path"
    send(path_name, path_options)
  end

  def scoped_new_page_path(path_options = {})
    scope = path_options.delete(:scope) || top_level_controller
    path_name = "new_admin_#{scope}_page_path"
    send(path_name, path_options)
  end

# Sorting and state params
  def human_status_param_key
    Page.human_attribute_name(:status).parameterize.to_sym
  end

  def human_sorting_param_key
    human_page_action_name(:sort).parameterize.to_sym
  end

  def parameterize_state(state_name)
    Page.human_state_name(state_name).parameterize.to_sym
  end

  def sorting_pages?
    state_param?(:published) && sorting_param.present?
  end

  def sorting_param
    params[human_sorting_param_key]
  end

  def state_param
    Page.state_key_for(params[human_status_param_key]) || :published
  end

  def state_param?(state_name)
    state_param == state_name.to_sym
  end

# Sort and state buttons
  def sort_pages_button
    return unless state_param?(:published) && @pages.count > 1

    content = sorting_pages? ?
      human_page_action_name(:end_sort) :
      human_page_action_name(:sort)

    path_options = params.slice human_status_param_key
    path_options[human_sorting_param_key] = 'si' if sorting_param.blank?

    link_to fa_icon(:sort, text: content.titleize), scoped_pages_path(path_options), class: 'btn btn-primary'
  end

  def page_status_segmented_control
    content_tag :div, class: 'btn-group' do
      %w(published drafted trashed).each do |state_name|
        concat page_state_segmented_button(state_name)
      end
    end
  end

# Html helpers
  def html_options_for_page_list
    html_options = { class: [ 'list-group', 'list-group-pages' ] }
    html_options[:class] << 'sortable' if sorting_pages?
    html_options[:class] = html_options[:class].join(' ')

    html_options[:data] = { update_url: sort_admin_pages_url } if sorting_pages?

    html_options
  end

  private
    def human_page_action_name(i18n_key)
      I18n.t i18n_key, scope: 'actions.admin.pages'
    end

    def page_state_segmented_button(state_name)
      css = [ 'btn', 'btn-default' ]
      css << 'active' if state_param?(state_name)

      content = Page.human_state_name(state_name)
      path_options = { human_status_param_key => parameterize_state(state_name) }

      link_to_unless state_param?(state_name), content, scoped_pages_path(path_options), class: css do
        button_tag content, type: :button, class: css
      end
    end
end