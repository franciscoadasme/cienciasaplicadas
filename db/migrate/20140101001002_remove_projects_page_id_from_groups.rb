class RemoveProjectsPageIdFromGroups < ActiveRecord::Migration
  def change
    remove_column :groups, :projects_page_id
  end
end
