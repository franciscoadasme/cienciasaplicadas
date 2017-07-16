class ContactMailer < DefaultMailer
  def contact_message(message)
    @message = message
    @group = Group.first

    mail to: @group.email,
         subject: I18n.t('mailers.contact.contact_message.subject'),
         template_path: 'mailer/contact'
  end
end
