class UserDecorator < Draper::Decorator
  include Draper::LazyHelpers

  delegate_all

  def avatar(size: 64)
    content_tag :div, class: 'img-avatar' do
      link_to post.author do
        h.autosizing_image_tag avatar_url, size: size.to_s
      end
    end
  end

  def avatar_url
    return object.image_url unless object.image_url.blank?
    image_url 'default_avatar.png'
  end

  def link
    link_to object.display_name, object
  end
end
