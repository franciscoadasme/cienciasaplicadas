class AbstractMailer < DefaultMailer
  def submission_token(abstract)
    @abstract = abstract
    @event = @abstract.event.decorate

    I18n.with_locale(@abstract.author.locale) do
      title = I18n.t 'mailers.abstracts.submission_token.subject',
                     event: @event.tagline
      mail to: @abstract.author.email,
           subject: title,
           template_path: 'mailer/abstracts'
    end
  end
end
