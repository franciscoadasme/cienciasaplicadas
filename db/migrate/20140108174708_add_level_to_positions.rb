class AddLevelToPositions < ActiveRecord::Migration
  def change
    add_column :positions, :level, :integer
  end
end
