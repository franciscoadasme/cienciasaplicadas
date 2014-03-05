class Admin::PostsController < AdminController
  before_action :authorize_user!
  before_action :set_post, only: [ :edit, :update, :destroy, :publish, :withhold ]

  def index
    @posts = Post.sorted
  end

  def new
    @post = Post.new
  end

  def edit
  end

  def create
    @post = Post.new(post_params)
    @post.author = @post.edited_by = current_user
    set_published_status

    if @post.save
      redirect_to_index success: (@post.published? ? :published : :drafted)
    else
      render action: 'new'
    end
  end

  def update
    @post.edited_by = current_user
    set_published_status

    if @post.update(post_params)
      redirect_to_index success: true
    else
      render action: 'edit'
    end
  end

  def destroy
    @post.destroy
    redirect_to_index success: true
  end

  def publish
    @post.publish!
    redirect_to_index success: true
  end

  def withhold
    @post.withhold!
    redirect_to_index success: true
  end

  private
    def authorize_user!
      redirect_to admin_path, alert: t('devise.failure.unauthorized') unless current_user.super_user?
    end

    def set_post
      @post = Post.friendly.find(params[:id])
    end

    def set_published_status
      @post.published = params.include? :publish
    end

    def post_params
      params.require(:post).permit(:title, :body)
    end
end