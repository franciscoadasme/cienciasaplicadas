class DefaultMailer < ActionMailer::Base
  default from: "#{Group.first.abbr} <noreply@#{ENV['MAIL_DOMAIN']}>"

  helper Admin::HtmlHelper
  helper UserHelper
  helper ApplicationHelper
  helper ParsingHelper

  def send_message(from, email, subject, body)
    @user = from
    @content = body

    @group = Group.first

    mail(to: email, subject: subject, template_path: 'mailer')
  end

  def send_contact_message(message)
    @sender = message.sender
    @email = message.email
    @content = message.body
    @as_student = message.as_student

    @group = Group.first
    subject = 'Una persona ha enviado un mensaje'

    mail to: @group.email, subject: subject, template_path: 'mailer'
  end

  def send_journal_notification(journals)
    return if journals.empty?
    recipients = User.admins.map{ |user| "#{user.display_name} <#{user.email}>" }
    subject = 'Se han agregado uno o más nuevas revistas'
    @journals = journals

    mail to: recipients, subject: subject, template_path: 'mailer'
  end

  def send_post_notification(post)
    @admins = User.admins
    recipients = @admins.map{ |user| "#{user.display_name} <#{user.email}>" }
    subject = 'Una noticia requiere de su aprobación'
    @post = post

    mail to: recipients, subject: subject, template_path: 'mailer'
  end

  private

  def recipients(users)
    if Rails.env.development?
      return ['Francisco Adasme <francisco.adasme@gmail.com>']
    end
    users.map { |user| "#{user.display_name} <#{user.email}>" }
  end
end
