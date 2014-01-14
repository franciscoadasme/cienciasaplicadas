class AddFlaggedToAuthors < ActiveRecord::Migration
  def change
    add_column :authors, :flagged, :boolean
  end
end
