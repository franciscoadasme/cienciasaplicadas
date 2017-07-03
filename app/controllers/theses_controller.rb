class ThesesController < SiteController
  decorates_assigned :theses, :thesis

  def index
    @theses = Thesis.sorted
  end

  def show
    @thesis = Thesis.includes(:user).friendly.find params[:id]
  end
end
