class AddCommonPagesToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :about_page_id, :integer
    add_column :groups, :front_page_id, :integer
    add_column :groups, :users_page_id, :integer
    add_column :groups, :pubs_page_id, :integer
  end
end
