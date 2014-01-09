class DefaultMailer < ActionMailer::Base
  default from: "#{Group.first.abbr} <noreply@#{ENV['MAILGUN_DOMAIN']}>"

  helper Admin::HtmlHelper
  helper UserHelper
  helper ApplicationHelper
  
  def self.mailgun
    @mailgun ||= Mailgun(
      api_key: ENV['MAILGUN_API_KEY'],
      domain: ENV['MAILGUN_DOMAIN'])
  end

  def send_announcement(from, emails, subject, body)
    @user = from
    @content = body

    @group = Group.first

    mail(to: emails,
         subject: "[Announcement] #{subject}",
         template_path: 'mailer')
  end
end