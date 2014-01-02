class RemovePageColumnsFromGroups < ActiveRecord::Migration
  def change
    remove_column :groups, :about_page_id
    remove_column :groups, :front_page_id
    remove_column :groups, :pubs_page_id
    remove_column :groups, :users_page_id
  end
end
