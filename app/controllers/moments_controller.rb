class MomentsController < SiteController
  decorates_assigned :moment, :moments

  def index
    @moments = Moment.sorted
  end

  def show
    @moment = Moment.find params[:id]
  end
end
