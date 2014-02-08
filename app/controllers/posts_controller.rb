class PostsController < SiteController
  include Filterable

  def index
    @posts = Post.published.sorted
    @posts = scope_with_date(@posts) if params[:year]
  end

  def show
    @posts = Post.published
    @post = Post.friendly.find params[:id]
  end
end