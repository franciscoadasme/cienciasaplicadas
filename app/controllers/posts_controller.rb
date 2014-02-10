class PostsController < SiteController
  include Filterable

  def index
    @posts = Post.published.sorted.during_date date_params
  end

  def show
    @posts = Post.published
    @post = Post.friendly.find params[:id]
  end
end