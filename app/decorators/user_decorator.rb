class UserDecorator < Draper::Decorator
  delegate_all

  def avatar(size: 64)
    h.content_tag :div, class: 'img-avatar' do
      h.link_to h.user_url(object) do
        h.autosizing_image_tag avatar_url, size: size.to_s
      end
    end
  end

  def avatar_url
    return object.image_url unless object.image_url.blank?
    h.image_url 'default_avatar.png'
  end

  def headline
    object.headline.try(:capitalize) || object.position.name
  end

  def link
    h.link_to object.display_name, h.user_url(object)
  end

  def mail_link
    return nil unless object.settings.show_contact_page
    h.mail_to object.email do
      h.fa_icon :'envelope-o', text: object.email
    end
  end

  def position_badge
    h.content_tag :span, object.position.name,
                  class: 'badge badge-outline-primary'
  end

  def project_info
    return nil unless object.projects.any?
    I18n.t('views.users.single.project_info_html',
           count: object.projects.count,
           url: h.user_projects_url(object)).html_safe
  end

  def pub_info
    return nil unless object.publications.any?
    I18n.t('views.users.single.pub_info_html',
           count: object.statistics.publication_total,
           url: h.user_publications_url(object),
           journals: object.statistics.journal_total).html_safe
  end
end
