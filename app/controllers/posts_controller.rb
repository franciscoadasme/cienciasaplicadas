class PostsController < SiteController
  def index
    @post = Post.published.first
    redirect_to @post rescue render(action: :show)
  end

  def show
    @posts = Post.published
    @post = Post.friendly.find params[:id]
  end
end