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

  def send_notification(subject, users, template)
    # users = User.where(nickname: 'fadasme') if Rails.env.development?
    mail(to: recipients(users),
         subject: subject,
         template_path: 'mailer/notification',
         template_name: template)
  end
end
