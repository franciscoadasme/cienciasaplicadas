class Admin::ContactsController < AdminController
  before_action :set_contact, only: [ :index, :show, :edit, :update, :destroy ]
  before_action :set_mailing_lists, only: [ :index, :show ]

  def index
    @contacts = Contact.sorted.group_by { |contact| contact.last_name.first }
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
      redirect_to [ :admin, @contact ], success: 'Contact was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @contact.update(contact_params)
      redirect_to [ :admin, @contact ], success: 'Contact was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @contact.destroy
    redirect_to admin_contacts_url
  end

  private
    def set_contact
      @contact = params.key?(:id) ? Contact.find(params[:id]) : Contact.sorted.first
    end

    def set_mailing_lists
      @mailing_lists = MailingList.all.reject { |ml| @contact.mailing_lists.include? ml }
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
