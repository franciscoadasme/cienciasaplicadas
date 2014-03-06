class ThesesController < SiteController
  include ThesesHelper

  def index
    @theses = Thesis.sorted
    @theses = @theses.with_keywords *keywords_param if keywords_param.any?
    @keywords = Thesis.keyword_list.uniq
  end

  def show
    @thesis = Thesis.friendly.find params[:id]
    @user = @thesis.user
  end
end
