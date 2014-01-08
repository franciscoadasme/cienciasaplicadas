class Admin::PositionsController < AdminController
  before_action :set_position, only: [:edit, :update, :destroy]

  def index
    @positions = Position.sorted
  end

  def new
    @position = Position.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @position = Position.new(position_params)

    if @position.save
      redirect_to admin_positions_path, success: 'Position was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @position.update(position_params)
      redirect_to admin_positions_path, success: 'Position was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @position.destroy
    redirect_to admin_positions_path
  end
  
  def sort
    params[:position].each_with_index do |id, index|
      Position.update_all({ level: index+1 }, { id: id })
    end
    render nothing: true
  end

  private
    def set_position
      @position = Position.find params[:id]
    end

    def position_params
      params.require(:position).permit :name
    end
end
