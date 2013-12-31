class ChangeVolumeTypeInPublications < ActiveRecord::Migration
  def change
    change_column :publications, :volume, :string
  end
end
