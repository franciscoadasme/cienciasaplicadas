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
    @page = Page.new(page_params)

    @page.owner = current_user unless top_level_controller?('group')
    @page.author = @page.edited_by = current_user
    set_published_status

    respond_to do |format|
      if @page.save
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
    params.delete(:tagline) if @page.marked?

    respond_to do |format|
      if @page.update(params)
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
    @page.trash! unless @page.marked?
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

  private
    def page_params
      params.require(:page).permit(:title, :tagline, :body)
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
