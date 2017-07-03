class AuthorDecorator < Draper::Decorator
  delegate_all

  def display_name
    object.name
  end

  def link
    return display_name unless has_user?
    h.link_to display_name, user
  end
end
