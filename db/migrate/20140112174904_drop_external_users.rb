class DropExternalUsers < ActiveRecord::Migration
  def change
    drop_table :external_users
  end
end
