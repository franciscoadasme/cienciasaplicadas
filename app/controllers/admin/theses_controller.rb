class Admin::ThesesController < AdminController
  before_action :set_thesis, only: [ :show, :edit, :update, :destroy ]

  def index
    @theses = Thesis.all
  end

  def show
  end

  def new
    @thesis = Thesis.new
    @users = User.joins(:position).where 'positions.slug LIKE ?', '%estudiante%'
  end

  def edit
  end

  def create
    @thesis = Thesis.new(thesis_params)

    if @thesis.save
      redirect_to [ :admin, @thesis ], success: true
    else
      render action: 'new'
    end
  end

  def update
    if @thesis.update(thesis_params)
      redirect_to [ :admin, @thesis ], success: true
    else
      render action: 'edit'
    end
  end

  def destroy
    @thesis.destroy
    redirect_to_index success: true
  end

  private
    def set_thesis
      @thesis = Thesis.find params[:id]
    end

    def thesis_params
      params.require(:thesis).permit(
        :title,
        :issued,
        :institution,
        :abstract,
        :notes,
        :keywords,
        :user_id,
        :pdf_file)
    end
end
