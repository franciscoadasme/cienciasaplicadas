class UserDecorator < Draper::Decorator
  delegate_all
  decorates_association :publications
  decorates_association :thesis

  def avatar(size: 64)
    img_tag = h.autosizing_image_tag avatar_url,
                                     class: 'user__image',
                                     size: size.to_s,
                                     alt: first_name
    # return h.content_tag(:span, img_tag, class: 'user__avatar') unless member?
    # h.link_to img_tag, h.user_url(object), class: 'user__avatar'
    h.content_tag(:span, img_tag, class: 'user__avatar')
  end

  def avatar_url
    return object.image_url unless object.image_url.blank?
    h.image_url 'default_avatar.png'
  end

  def display_name
    accepted? ? full_name : email
  end

  def headline
    object.headline.try(:capitalize) || object.position.name
  end

  def link(name = nil, options = nil)
    name, options = options, name if name.is_a? Hash
    name ||= display_name
    return name unless object.member?
    h.link_to name, h.user_url(object), options
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

  def social_links
    return {} if object.social_links.blank?
    Hash[object.social_links.split(/\n/).map { |line| line[1..-1].split }]
  end

  def research_gate_url
    "https://www.researchgate.net/profile/#{research_gate}" unless research_gate.blank?
  end
end
