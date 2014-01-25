class Admin::MomentsController < AdminController
  before_action :authorize_user!
  before_action :set_moment, only: [:show, :edit, :update, :destroy]

  def index
    @moments = Moment.sorted
  end

  def show
  end

  def new
    @moment = Moment.new
    @moment.taken_on = Date.today
    @moment.user = current_user
  end

  def edit
  end

  def create
    @moment = Moment.new(moment_params)

    respond_to do |format|
      if @moment.save
        format.html { redirect_to admin_moments_path, notice: 'Moment was successfully created.' }
        format.json { render action: 'show', status: :created, location: @moment }
      else
        format.html { render action: 'new' }
        format.json { render json: @moment.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @moment.update(moment_params)
        format.html { redirect_to admin_moments_path, notice: 'Moment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @moment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @moment.destroy
    respond_to do |format|
      format.html { redirect_to admin_moments_url }
      format.json { head :no_content }
    end
  end

  private
    def set_moment
      @moment = Moment.find(params[:id])
    end

    def moment_params
      params.require(:moment).permit(:photo, :taken_on, :user_id, :caption)
    end
end
