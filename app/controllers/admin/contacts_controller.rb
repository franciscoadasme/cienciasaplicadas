class Admin::ContactsController < AdminController
  before_action :authorize_user!
  before_action :set_contact, only: [ :show, :edit, :update, :destroy ]
  before_action :set_mailing_lists, only: [ :index, :show ]

  def index
    @contacts = Contact.sorted.group_by { |contact| contact.last_name.first }
    @contact = Contact.sorted.first
  end

  def show
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @contact = Contact.new
  end

  def edit
  end

  def create
    @contact = Contact.new(contact_params)

    if @contact.save
      redirect_to [ :admin, @contact ], success: true
    else
      render action: 'new'
    end
  end

  def update
    if @contact.update(contact_params)
      redirect_to [ :admin, @contact ], success: true
    else
      render action: 'edit'
    end
  end

  def destroy
    @contact.destroy
    redirect_to_index success: true
  end

  private
    def set_contact
      @contact = Contact.find(params[:id])
    end

    def set_mailing_lists
      @mailing_lists = MailingList.all
    end

    def contact_params
      params.require(:contact).permit(
        :first_name,
        :last_name,
        :institution,
        :email,
        :website_url)
    end
end
