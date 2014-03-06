module Admin::PostsHelper
  def post_submit_button(buider, post)
    i18n_scope = 'helpers.submit.post'
    i18n_key = case
      when !current_user.admin? then :draft
      when post.persisted? && post.published? then :update
      else :publish
    end
    content = I18n.t i18n_key, scope: i18n_scope
    name = current_user.admin? ? :publish : :draft

    buider.button :submit, content, name: name, class: 'btn btn-primary', data: { disable_with: 'Enviando...' }
  end
end
