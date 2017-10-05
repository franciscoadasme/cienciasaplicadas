class AbstractMailer < DefaultMailer
  def submission_token(abstract)
    notification :submission_token, abstract
  end

  def submission_confirmation(abstract)
    notification :submission_confirmation, abstract
  end

  private

  def notification(notification_name, abstract)
    @abstract = abstract
    @event = @abstract.event.decorate

    I18n.with_locale(@abstract.author.locale) do
      title = I18n.t "mailers.abstracts.#{notification_name}.subject",
                     event: @event.tagline
      mail to: @abstract.author.email,
           subject: title,
           template_path: 'mailer/abstracts',
           template_name: notification_name.to_s
    end
  end
end
