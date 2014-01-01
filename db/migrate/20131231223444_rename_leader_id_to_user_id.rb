class RenameLeaderIdToUserId < ActiveRecord::Migration
  def change
    rename_column :projects, :leader_id, :user_id
  end
end
