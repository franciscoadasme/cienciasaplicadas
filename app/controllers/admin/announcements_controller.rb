module Admin
  class AnnouncementsController < AdminController
    include NotifiableController

    before_action :authorize_user!

    def new
      @message = Message.new
      @positions = Position.sorted
    end

    def create
      @message = Message.new message_params
      if @message.valid? && valid_recipients?
        send_new_notification_if_needed @message
        redirect_to admin_path, success: true
      else
        @positions = Position.sorted
        render action: 'new'
      end
    end

    private

    def message_params
      params.require(:message).permit(:subject, :body)
    end

    def valid_recipients?
      return true if notification_recipients.any?
      flash[:error] = I18n.t('activemodel.errors.models.message.no_recipients')
      false
    end
  end
end
