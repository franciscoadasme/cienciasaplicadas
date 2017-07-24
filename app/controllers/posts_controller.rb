class PostsController < SiteController
  # TODO: make this global
  before_action :set_locale, only: [:show, :posts, :registration, :speakers]
  decorates_assigned :posts, :post

  def index
    @posts = Post.global.locale(I18n.locale).published.sorted
  end

  def show
    @post = Post.friendly.find(params[:id]).translate(I18n.locale)
    @post.increment_view_count!
  end

  private

  def set_locale
    I18n.locale = params[:lang] || I18n.default_locale
  end
end
