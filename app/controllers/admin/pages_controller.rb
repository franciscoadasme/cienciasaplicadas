class Admin::PagesController < AdminController
  before_action :set_page, except: [ :index, :new, :create, :sort ]
  before_action except: [ :index, :new, :create ] do
    redirect_to_index alert: 'You do not have authorization to modify this page' unless current_user.super_user? || @page.owner != current_user
  end
  before_action only: [ :edit, :update, :publish, :trash ] do
    redirect_to_index alert: 'You cannot edit nor update a trashed page' if @page.trashed?
  end

  # GET /pages
  # GET /pages.json
  def index
    @pages = top_level_controller?('group') ? Page.global : current_user.pages

    params[:status] ||= 'published'
    conditions = { }
    conditions[:published] = true if params[:status] == 'published'
    conditions[:published] = false if params[:status] == 'drafted'
    conditions[:trashed] = params[:status] == 'trashed'
    @pages = @pages.where conditions
  end

  # GET /pages/new
  def new
    @page = Page.new
  end

  # GET /pages/1/edit
  def edit
  end

  # POST /pages
  # POST /pages.json
  def create
    params = page_params
    type = params.delete :marked_as
    @page = Page.new(params)

    @page.owner = current_user unless top_level_controller?('group')
    @page.author = @page.edited_by = current_user
    set_published_status

    respond_to do |format|
      if @page.save
        @group.mark_page_as!(@page, type) unless type.nil?
        format.html { redirect_to_index success: "Page was successfully #{@page.published? ? 'published' : 'saved as draft'}." }
        format.json { render action: 'show', status: :created, location: @page }
      else
        format.html { render action: 'new' }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pages/1
  # PATCH/PUT /pages/1.json
  def update
    @page.edited_by = current_user
    set_published_status

    params = page_params
    type = params.delete :marked_as
    params.delete(:tagline) if @page.marked?

    respond_to do |format|
      if @page.update(params)
        type.present? ? @group.mark_page_as!(@page, type) : @group.unmark_page!(@page)
        format.html { redirect_to_index success: 'Page was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pages/1
  # PATCH/PUT /pages/1.json
  def publish
    @page.publish!
    respond_to do |format|
      format.html { redirect_to_index success: 'Page was successfully published.' }
      format.json { head :no_content }
    end
  end

  # PATCH/PUT /pages/1
  # PATCH/PUT /pages/1.json
  def trash
    @page.trash!
    respond_to do |format|
      format.html { redirect_to_index success: 'Page was moved to trash.' }
      format.json { head :no_content }
    end
  end

  # PATCH/PUT /pages/1
  # PATCH/PUT /pages/1.json
  def restore
    @page.restore!
    respond_to do |format|
      format.html { redirect_to_index success: "Page was successfully restored as #{@page.status}." }
      format.json { head :no_content }
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.json
  def destroy
    @page.destroy
    respond_to do |format|
      format.html { redirect_to_index success: "Page was deleted permanently." }
      format.json { head :no_content }
    end
  end

  def sort
    params[:page].each_with_index do |id, index|
      Page.update_all({ position: index+1 }, { id: id })
    end
    render nothing: true
  end

  def mark_as_about; mark_as :about; end
  def mark_as_front; mark_as :front; end
  def mark_as_publications; mark_as :pubs; end
  def mark_as_users; mark_as :users; end
  def mark_as_projects; mark_as :projects; end

  def unmark
    @group.unmark_page! @page unless @page.owner.present?
    redirect_to_index success: "Page was unmarked successfully"
  end

  private
    def mark_as(type)
      @group.mark_page_as! @page, type
      redirect_to_index success: "Page was marked as #{type.to_s.titleize} successfully"
    end

    def page_params
      params.require(:page).permit(:title, :tagline, :body, :marked_as)
    end

    def set_page
      @page = Page.find(params[:id])
    end

    def set_published_status
      @page.published = params.include? :publish
    end

    def redirect_to_index options = {}
      options[:status] ||= @page.status if @page.persisted?
      redirect_to send("admin_#{@page.associated_controller}_pages_path", status: options.delete(:status)), options
    end
end
