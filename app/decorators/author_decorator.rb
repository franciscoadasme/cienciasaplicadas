class AuthorDecorator < Draper::Decorator
  delegate_all

  def display_name
    object.name
  end

  def link
    return display_name unless has_user?
    user.link display_name
  end

  private

  def user
    @user ||= object.user.decorate
  end
end
