class PostsController < SiteController
  def index
    @posts = Post.published.sorted.during_date date_params
  end

  def show
    @posts = Post.published
    @post = Post.friendly.find params[:id]
    @post.increment_view_count!
  end
end
