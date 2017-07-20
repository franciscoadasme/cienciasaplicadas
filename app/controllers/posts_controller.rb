class PostsController < SiteController
  decorates_assigned :posts, :post

  def index
    @posts = Post.global.published.sorted
  end

  def show
    @post = Post.friendly.find params[:id]
    @post.increment_view_count!
  end
end
