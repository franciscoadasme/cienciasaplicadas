class AddViewCountToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :view_count, :integer, default: 0, null: false
  end
end
