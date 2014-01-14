class RemoveClaimedFromPublications < ActiveRecord::Migration
  def change
    remove_column :publications, :claimed, :boolean
  end
end
