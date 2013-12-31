class AddClaimedToPublications < ActiveRecord::Migration
  def change
    add_column :publications, :claimed, :boolean, default: false
  end
end
