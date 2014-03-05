class Admin::PagesController < AdminController
  include Admin::PagesHelper

  before_action :set_page, except: [ :index, :new, :create, :sort ]
  before_action except: [ :index, :new, :create ] do
    redirect_to_index alert: :unauthorized unless current_user.super_user? || @page.owner == current_user
  end
  before_action only: [ :edit, :update, :publish, :trash ] do
    redirect_to_index alert: :cannot_modify_trashed if @page.trashed?
  end

  def index
    @pages = top_level_controller?('group') ? Page.global : current_user.pages
    @pages = @pages.send(state_param)
  end

  def new
    @page = Page.new
  end

  def edit
  end

  def create
    @page = Page.new(page_params)

    @page.owner = current_user unless top_level_controller?('group')
    @page.author = @page.edited_by = current_user
    set_published_status

    if @page.save
      redirect_to_index success: (@page.published? ? :published : :drafted)
    else
      render action: 'new'
    end
  end

  def update
    @page.edited_by = current_user
    set_published_status

    params = page_params
    params.delete(:tagline) if @page.marked?

    if @page.update(params)
      redirect_to_index success: true
    else
      render action: 'edit'
    end
  end

  def publish
    @page.publish!
    redirect_to_index success: true
  end

  def trash
    @page.trash! unless @page.marked?
    redirect_to_index success: true
  end

  def restore
    @page.restore!
    redirect_to_index success: { status: @page.status }
  end

  def destroy
    @page.destroy
    redirect_to_index success: true
  end

  def sort
    params[:page].each_with_index do |id, index|
      Page.update_all({ position: index+1 }, { id: id })
    end
    render nothing: true
  end

  private
    def page_params
      params.require(:page).permit(:title, :tagline, :body, :banner)
    end

    def set_page
      @page = Page.find(params[:id])
    end

    def set_published_status
      @page.published = params.include? :publish
    end

    def redirect_to_index response_status = {}
      path_options = response_status.extract! human_status_param_key
      path_options[human_status_param_key] ||= parameterize_state(@page.status) if @page.persisted?
      path_options[:scope] = @page.owner.nil? && current_user.super_user? ? :group : :account
      redirect_to scoped_pages_path(path_options), response_status
    end
end
