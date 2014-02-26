module UserHelper
  def display_user_name user
    is_me?(user) ? 'me' : user.display_name
  end

  def display_user_image_url user
    (user.image_url.blank? ? nil : user.image_url) || gravatar_image_url(user.email) || 'asdasd'
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
end
