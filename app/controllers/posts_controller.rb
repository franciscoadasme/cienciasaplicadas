class PostsController < SiteController
  def index
    @posts = Post.published.sorted.during_date params.slice(:year, :month, :day)
  end

  def show
    @posts = Post.published
    @post = Post.friendly.find params[:id]
  end
end