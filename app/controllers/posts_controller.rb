class PostsController < SiteController
  def index
    @posts = Post.published.sorted
  end

  def show
    @posts = Post.published
    @post = Post.friendly.find params[:id]
  end
end