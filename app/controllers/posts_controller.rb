class PostsController < SiteController
  decorates_assigned :posts, :post

  def index
    @posts = Post.published.sorted.during_date date_params
  end

  def show
    @post = Post.friendly.find params[:id]
    @post.increment_view_count!
  end
end
