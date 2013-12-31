class AddProjectsPageIdToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :projects_page_id, :integer
  end
end
