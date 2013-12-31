class CreateExternalUsersProjects < ActiveRecord::Migration
  def change
    create_table :external_users_projects do |t|
      t.references :project, index: true
      t.references :external_user, index: true
    end
  end
end
