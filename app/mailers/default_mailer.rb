class DefaultMailer < ActionMailer::Base
  default from: "#{Group.first.abbr} <noreply@#{ENV['MAILGUN_DOMAIN']}>"

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
    subject = '[CienciasAplicadas] Una persona ha enviado un mensaje'

    mail to: @group.email, subject: subject, template_path: 'mailer'
  end
end