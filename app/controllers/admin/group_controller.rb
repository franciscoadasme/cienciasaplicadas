class Admin::GroupController < AdminController
  # GET /account/groups/1/edit
  def edit
  end

  # PATCH/PUT /account/groups/1
  # PATCH/PUT /account/groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to customize_admin_group_path, success: 'Group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
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
