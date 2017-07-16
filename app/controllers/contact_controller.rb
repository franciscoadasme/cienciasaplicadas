class ContactController < SiteController
  def new
    @message = ContactMessage.new
  end

  def create
    @message = ContactMessage.new contact_params
    if @message.valid?
      ContactMailer.contact_message(@message).deliver
      flash[:success] = I18n.t 'controllers.success.contact.message_sent'
      redirect_to action: :new
    else
      flash.now[:error] = I18n.t 'controllers.errors.contact.invalid_message'
      render action: :new
    end
  end

  private

  def contact_params
    params.require(:contact_message).permit(
      :sender_name,
      :sender_email,
      :body,
      :as_student
    )
  end
end
