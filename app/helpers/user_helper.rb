module UserHelper
  def display_user_name user
    is_me?(user) ? 'Mí' : user.display_name
  end

  def display_user_image_url user
    (user.image_url.blank? ? nil : user.image_url) || gravatar_image_url(user.email)
  end

  def display_user_headline(user)
    user.headline || content_tag(:span, 'Titular', class: 'text-muted')
  end

  def is_me? user
    current_user == user
  end

  def is_not_me? user
    !is_me?(user)
  end

  def section_title_for_user_pubs(pubs)
    pubs.first.flagged_by?(@user) ?
      'Publicaciones destacadas' :
      'Últimas Publicaciones'
  end

  def default_user_scope
    params[:controller].classify.constantize.model_name.human.pluralize(:'es-CL').titleize + ' de'
  end

  def format_social_links(content)
    content_tag :ul, class: 'list-unstyled' do
      content.split(/\n/).each do |line|
        service, url = line.split
        concat social_link_item(service.delete(':'), url)
      end
    end
  end

  private
    def social_link_item(service, url)
      content_tag :li do
        btn_to fa_icon(service, text: service.titleize), url, block: true
      end
    end
end
