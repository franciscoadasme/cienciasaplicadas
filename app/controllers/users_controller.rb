class UsersController < SiteController
  before_action :set_user, only: [ :show ]

  def show
    page_id = params[:page_id]
    case page_id
    when 'about', nil
      @page = Page.new title: "Hi, I'm #{@user.first_name}", body: @user.bio
    when 'publications', 'projects'
      @page = Page.new title: page_id.titleize, body: "{{ @user.#{page_id} }}"
    else
      @page = @user.pages.friendly.find page_id
    end

    @user_pages = @user.pages.published
  end

  private
    def set_user
      @user = User.friendly.find(params[:id])
    end
end