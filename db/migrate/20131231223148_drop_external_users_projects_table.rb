class DropExternalUsersProjectsTable < ActiveRecord::Migration
  def change
    drop_table :external_users_projects
  end
end
