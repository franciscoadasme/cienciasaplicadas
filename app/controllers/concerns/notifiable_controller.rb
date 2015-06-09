module NotifiableController
  extend ActiveSupport::Concern

  def notification_params
    params.require(:notification).permit position_ids: []
  end

  def send_new_notification_if_needed(record)
    position_ids = notification_params.fetch(:position_ids, []).reject(&:blank?)
    return if position_ids.empty?

    users = User.default.joins(:position)
            .where('positions.id' => position_ids)
    notifier = "send_new_#{record.class.name.underscore}_notification"
    NotificationMailer.send(notifier, record, users).deliver
  end
end
