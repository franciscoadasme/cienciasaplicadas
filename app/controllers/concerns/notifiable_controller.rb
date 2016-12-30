module NotifiableController
  extend ActiveSupport::Concern

  def position_ids
    notification_params.fetch(:position_ids, []).reject(&:blank?)
  end

  def notification_params
    params.require(:notification).permit position_ids: []
  end

  def send_new_notification_if_needed(record)
    return if position_ids.empty?
    notifier = "send_new_#{record.class.name.underscore}_notification"
    NotificationMailer.send(notifier, record, notification_recipients).deliver
  end

  def notification_recipients
    @recipients ||= User.default.joins(:position)
                        .where('positions.id' => position_ids)
  end
end
