class DefaultMailer < ActionMailer::Base
  default from: "#{Group.first.abbr} <noreply@#{ENV['MAILGUN_DOMAIN']}>"

  helper Admin::HtmlHelper
  helper UserHelper
  helper ApplicationHelper

  def send_message(from, email, subject, body)
    @user = from
    @content = body

    @group = Group.first

    mail(to: email, subject: subject, template_path: 'mailer')
  end
end