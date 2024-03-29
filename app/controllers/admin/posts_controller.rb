class Admin::PostsController < AdminController
  include NotifiableController

  before_action :authorize_user!
  before_action :set_post, only: [ :edit, :update, :destroy, :publish, :withhold, :localized ]
  # after_action :send_notification, only: [ :create, :update ]

  def index
    @posts = Post.global.main.sorted
  end

  def new
    @post = Post.new
    @post.event = Event.find(params[:event]) if params.key?(:event)
    @post.parent = Post.find(params[:parent]) if params.key?(:parent)
    @positions = Position.sorted
  end

  def edit
  end

  def create
    @post = Post.new(post_params)
    @post.author = @post.edited_by = current_user
    set_published_status

    if @post.save
      send_new_notification_if_needed @post
      if @post.event.present?
        redirect_to posts_admin_event_path(@post.event)
      else
        redirect_to_index_after_save
      end
    else
      @positions = Position.sorted
      render action: 'new'
    end
  end

  def update
    @post.edited_by = current_user
    set_published_status

    if @post.update(post_params)
      if @post.event.present?
        redirect_to posts_admin_event_path(@post.event)
      else
        redirect_to_index_after_save
      end
    else
      render action: 'edit'
    end
  end

  def destroy
    @post.destroy
    if @post.event.present?
      redirect_to posts_admin_event_path(@post.event)
    else
      redirect_to_index success: true
    end
  end

  def publish
    @post.publish!
    redirect_to_index success: :published
  end

  def withhold
    @post.withhold!
    redirect_to_index success: true
  end

  def localized
    @posts = @post.localized.sorted
  end

  private
    def authorize_user!
      redirect_to admin_path, alert: t('devise.failure.unauthorized') unless current_user.super_user?
    end

    def set_post
      @post = Post.friendly.find(params[:id])
    end

    def set_published_status
      @post.published = params.include?(:publish) && current_user.admin?
    end

    def post_params
      post_params = params.require(:post).permit(:title, :body, :event_id,
                                                 :parent_id, :locale)
      post_params[:locale] ||= I18n.default_locale
      post_params
    end

    def redirect_to_index_after_save
      i18n_key = case
        when current_user.admin?
          @post.published? ? :published : :drafted
        else
          :drafted_with_notification
      end
      redirect_to admin_posts_path(anchor: "post_#{@post.id}"), success: i18n_key
    end

    # def send_notification
    #   DefaultMailer.send_post_notification(@post).deliver unless current_user.admin?
    # end
end
