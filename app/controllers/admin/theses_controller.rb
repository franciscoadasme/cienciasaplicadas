class Admin::ThesesController < AdminController
  before_action :set_thesis, only: [ :show, :edit, :update, :destroy ]

  def index
    @theses = Thesis.all
  end

  def show
  end

  def new
    @thesis = Thesis.new
  end

  def edit
  end

  def create
    @thesis = Thesis.new(thesis_params)

    if @thesis.save
      redirect_to [ :admin, @thesis ], notice: 'Thesis was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @thesis.update(thesis_params)
      redirect_to [ :admin, @thesis ], notice: 'Thesis was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @thesis.destroy
    redirect_to admin_theses_url
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
