class EventMailer < DefaultMailer
  helper ContentHelper

  def registration_accepted(attendee)
    registration_notification attendee, status: :accepted
  end

  def registration_rejected(attendee)
    registration_notification attendee, status: :rejected
  end

  private

  def registration_notification(attendee, status:)
    @event = attendee.event.decorate
    title = @event.name.truncate(60, separator: /\s+/)
    title = I18n.t "mailers.events.registration_#{status}.subject", event: title
    mail to: attendee.email,
         subject: title,
         template_path: 'mailer/events',
         template_name: "registration_#{status}"
  end
end
