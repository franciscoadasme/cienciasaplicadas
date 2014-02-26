class PublicationsController < ApplicationController
  before_action :set_user
  def index
    @pubs = @user.publications.sorted
    @years = @pubs.pluck(:year).uniq
    @last_update = @user.publications.order(updated_at: :desc).first.updated_at
  end

  private
    def set_user
      @user = User.friendly.find params[:user_id]
    end
end
