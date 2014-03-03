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

    if @moment.save
      redirect_to_index success: true
    else
      render action: 'new'
    end
  end

  def update
    if @moment.update(moment_params)
      redirect_to_index success: true
    else
      render action: 'edit'
    end
  end

  def destroy
    @moment.destroy
    redirect_to_index success: true
  end

  private
    def set_moment
      @moment = Moment.find(params[:id])
    end

    def moment_params
      params.require(:moment).permit(:photo, :taken_on, :user_id, :caption)
    end
end
