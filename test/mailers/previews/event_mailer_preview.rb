class EventMailerPreview < ActionMailer::Preview
  def registration_accepted
    EventMailer.registration_accepted(Attendee.first)
  end

  def registration_rejected
    EventMailer.registration_rejected(Attendee.first)
  end
end
