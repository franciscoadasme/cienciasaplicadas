class AddOverviewToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :overview, :text
  end
end
