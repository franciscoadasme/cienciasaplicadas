class SpeakerDecorator < Draper::Decorator
  delegate_all

  def avatar(size: 64)
    if website_url.present?
      h.link_to image_tag(size), website_url, class: 'user__avatar'
    else
      h.content_tag(:div, image_tag(size), class: 'user__avatar')
    end
  end

  def avatar_url
    return object.photo(:thumb) unless object.photo.blank?
    h.image_url 'default_avatar.png'
  end

  def link(options = nil)
    return name unless website_url.present?
    h.link_to name, website_url, options
  end

  private

  def image_tag(size)
    h.autosizing_image_tag avatar_url, class: 'user__image', size: size.to_s
  end
end
