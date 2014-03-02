class Admin::MailingListsController < AdminController
  before_action :authorize_user!
  before_action :set_mailing_list, only: [ :show, :edit, :update, :destroy,
    :add_member, :remove_member,
    :new_message, :send_message ]
  before_action :validate_mailing_list, only: [ :edit, :update, :destroy,
    :add_member, :remove_member ]

  def index
    @mailing_lists = MailingList.all
  end

  def show
  end

  def new
    @mailing_list = MailingList.new
  end

  def edit
  end

  def create
    @mailing_list = MailingList.new(mailing_list_params)

    if @mailing_list.create
      redirect_to [ :admin, @mailing_list ], success: true
    else
      render action: 'new'
    end
  end

  def update
    if @mailing_list.update(mailing_list_params)
      redirect_to [ :admin, @mailing_list ], success: true
    else
      render action: 'edit'
    end
  end

  def destroy
    @mailing_list.destroy
    redirect_to_index success: true
  end

  def add_member
    if params[:mailing_list_member]
      @addresses_taken = @mailing_list.addresses
      addresses = params[:mailing_list_member][:address].strip.split(',')
      addresses.each do |address|
        @mailing_list.add_member(address) unless @addresses_taken.include?(address)
      end
    end

    respond_to do |format|
      format.html { redirect_to [ :admin, @mailing_list ], success: true }
      format.js do
        @addresses_taken = @mailing_list.addresses
        @addresses_available = User.pluck(:email).concat(Contact.pluck(:email)).reject { |address| @addresses_taken.include? address }
      end
    end
  end

  def remove_member
    @mailing_list.remove_member params[:address]
    redirect_to [ :admin, @mailing_list ], notice: true
  end

  def new_message
    @message = Message.new
  end

  def send_message
    @message = Message.new message_params
    @message.from = current_user
    @message.to = @mailing_list.address

    if @message.valid?
      @message.deliver
      redirect_to [ :admin, @mailing_list ], success: true
    else
      render action: 'new_message'
    end
  end

  private
    def set_mailing_list
      @mailing_list = MailingList.find params[:id]
    end

    def mailing_list_params
      params.require(:mailing_list).permit(:name, :address, :description)
    end

    def message_params
      params.require(:message).permit(:subject, :body)
    end

    def validate_mailing_list
      redirect_to_index alert: :reserved if @mailing_list.reserved?
    end
end
