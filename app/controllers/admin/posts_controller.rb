class Admin::PostsController < AdminController
  before_action :authorize_user!
  before_action :set_post, only: [ :edit, :update, :destroy, :publish, :withhold ]
  # after_action :send_notification, only: [ :create, :update ]

  def index
    @posts = Post.sorted
  end

  def new
    @post = Post.new
    @positions = Position.sorted
  end

  def edit
  end

  def create
    @post = Post.new(post_params)
    @post.author = @post.edited_by = current_user
    set_published_status

    if @post.save
      send_new_post_notification_if_needed @post
      redirect_to_index_after_save
    else
      @positions = Position.sorted
      render action: 'new'
    end
  end

  def update
    @post.edited_by = current_user
    set_published_status

    if @post.update(post_params)
      redirect_to_index_after_save
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
    redirect_to_index success: :published
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
      @post.published = params.include?(:publish) && current_user.admin?
    end

    def post_params
      params.require(:post).permit(:title, :body)
    end

    def notification_params
      params.require(:notification).permit position_ids: []
    end

    def redirect_to_index_after_save
      i18n_key = case
        when current_user.admin?
          @post.published? ? :published : :drafted
        else
          :drafted_with_notification
      end
      redirect_to_index success: i18n_key
    end

  def send_new_post_notification_if_needed(post)
    position_ids = notification_params.fetch(:position_ids, []).reject(&:blank?)
    return if position_ids.empty?

    users = User.default.joins(:position)
            .where('positions.id' => position_ids)
    NotificationMailer.send_new_post_notification(post, users).deliver
  end

    # def send_notification
    #   DefaultMailer.send_post_notification(@post).deliver unless current_user.admin?
    # end
end
