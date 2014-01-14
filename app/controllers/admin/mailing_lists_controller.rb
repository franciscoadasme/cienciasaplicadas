class Admin::MailingListsController < AdminController
  before_action :authorize_user!
  before_action :set_mailing_list, only: [ :show, :edit, :update, :destroy,
    :add_member, :remove_member,
    :new_message, :send_message ]

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

    respond_to do |format|
      if @mailing_list.create
        format.html { redirect_to [ :admin, @mailing_list ], success: 'Mailing list was successfully created.' }
        format.json { render action: 'show', status: :created, location: @mailing_list }
      else
        format.html { render action: 'new' }
        format.json { render json: @mailing_list.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @mailing_list.update(mailing_list_params)
        format.html { redirect_to [ :admin, @mailing_list ], success: 'Mailing list was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @mailing_list.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @mailing_list.destroy
    respond_to do |format|
      format.html { redirect_to admin_mailing_lists_url }
      format.json { head :no_content }
    end
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
      format.html { redirect_to [ :admin, @mailing_list ], success: 'Recipients added successfully.' }
      format.js do
        @addresses_taken = @mailing_list.addresses
        @addresses_available = User.pluck(:email).concat(Contact.pluck(:email)).reject { |address| @addresses_taken.include? address }
      end
    end
  end

  def remove_member
    @mailing_list.remove_member params[:address]
    redirect_to [ :admin, @mailing_list ], notice: 'Recipient removed successfully.'
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
      redirect_to [ :admin, @mailing_list ], success: 'Message delivered.'
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
end
