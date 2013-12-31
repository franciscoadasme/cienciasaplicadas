class Admin::AnnouncementsController < AdminController
  before_filter :authorize_user!

  def new
    @post = Post.new
  end

  def create
    @post = Post.new params.require(:post).permit(:title, :body)
    if @post.valid?
      DefaultMailer.send_announcement(
        current_user,
        User.where.not(id: current_user.id).map{ |u| "#{u.full_name} <#{u.email}>" },
        @post.title,
        @post.body
      ).deliver
      redirect_to admin_path, success: 'Announcement sent successfully.'
    else
      render action: :new
    end
  end

  private
    def authorize_user!
      redirect_to admin_users_path, alert: t('devise.failure.unauthorized') unless current_user.super_user?
    end
end