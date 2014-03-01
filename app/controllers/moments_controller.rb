class MomentsController < SiteController
  def index
    date_attr = date_params
    @moments = Moment.sorted.during_date date_attr

    begin
      @date = Date.new date_attr[:year].to_i, date_attr[:month].to_i, 1
      unit = date_attr.has_key?(:month) ? :month : :year
      @end_date = @date.send "end_of_#{unit}"
    rescue ArgumentError
      @end_date = DateTime.current
    end
  end

  def show
    @moment = Moment.find params[:id]
  end
end
