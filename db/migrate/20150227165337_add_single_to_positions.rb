class AddSingleToPositions < ActiveRecord::Migration
  def change
    add_column :positions, :single, :bool, default: false
  end
end
