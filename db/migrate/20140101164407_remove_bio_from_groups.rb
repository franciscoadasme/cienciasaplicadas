class RemoveBioFromGroups < ActiveRecord::Migration
  def change
    remove_column :groups, :bio, :string
  end
end
