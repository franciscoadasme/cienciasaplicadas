class AddViewCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :view_count, :integer
  end
end
