class NotificationMailer < DefaultMailer
  helper :posts
  helper :pages

  def send_new_event_notification(event, users)
    @event = event
    send_notification(
      event.name.truncate(120, separator: /\s/),
      users,
      'new_event_notification')
  end

  def send_new_post_notification(post, users)
    @post = post
    send_notification(
      post.title.truncate(120, separator: /\s/),
      users,
      'new_post_notification')
  end

  def send_new_message_notification(message, users)
    @body = message.body
    send_notification(message.subject, users, 'new_message_notification')
  end

  private

  def new_request(subject, email, template)
    mail(to: email,
         subject: subject,
         template_path: 'mailer/notification',
         template_name: template)
  end

  def send_notification(subject, users, template)
    addr_list = recipients(users)
    new_request(subject, addr_list, template).tap do |email|
      email.mailgun_recipient_variables = Hash[addr_list.map { |a| [a, {}] }]
    end
  end
end
