class PostsController < SiteController
  def index
    @posts = Post.published.sorted
    if params[:year]
      date = Date.new params[:year].to_i, (params[:month] || 1).to_i
      from_date = date.beginning_of_month
      to_date = date.end_of_month
      @posts = @posts.where created_at: from_date..to_date
    end
  end

  def show
    @posts = Post.published
    @post = Post.friendly.find params[:id]
  end
end