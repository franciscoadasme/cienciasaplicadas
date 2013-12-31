class DefaultMailer < ActionMailer::Base
  default from: "#{Group.first.abbr} <noreply@cbsm.cl>"

  helper Admin::HtmlHelper
  helper UserHelper
  helper ApplicationHelper

  def send_announcement(from, emails, subject, body)
    @user = from
    @content = body

    @group = Group.first

    mail(to: emails,
         subject: "[Announcement] #{subject}",
         template_path: 'mailer')
  end
end