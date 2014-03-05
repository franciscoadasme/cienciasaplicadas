class Admin::GroupController < AdminController
  def edit
  end

  def update
    if @group.update(group_params)
      redirect_to customize_admin_group_path, success: true
    else
      render action: 'edit'
    end
  end

  private
    def group_params
      params.require(:group).permit(
        # :name,
        # :abbr,
        # :logo,
        :email,
        # :bio,
        # :banner_image_url,
        # :tagline,
        # :address,
        :overview
      )
    end
end
