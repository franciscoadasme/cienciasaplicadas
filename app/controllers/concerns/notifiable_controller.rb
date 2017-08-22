module NotifiableController
  extend ActiveSupport::Concern

  def position_ids
    notification_params.fetch(:position_ids, []).reject(&:blank?)
  end

  def notification_params
    params.require(:notification).permit position_ids: []
  end

  def send_new_notification_if_needed(record)
    return unless send_notification?
    notifier = "send_new_#{record.class.name.underscore}_notification"
    NotificationMailer.send(notifier, record, notification_recipients).deliver
  end

  def notification_recipients
    @recipients ||= begin
      recipients = User.default.joins(:position)
                       .where('positions.id' => position_ids).to_a
      # if notify_attendees? is true, then @post.event exists and it's not nil
      recipients.concat @post.event.attendees if notify_attendees?
      recipients
    end
  end

  private

  def notify_attendees?
    params[:notification].key?(:attendees)
  end

  def send_notification?
    return false unless params.key?(:notification)
    position_ids.any? || notify_attendees?
  end
end
