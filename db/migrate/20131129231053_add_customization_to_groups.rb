class AddCustomizationToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :banner_image_url, :string
    add_column :groups, :tagline, :string
    add_column :groups, :address, :text
  end
end
